create table suppliers (
 id uuid primary key default gen_random_uuid(), code text not null unique, name text not null,
 tax_number text not null default '', verified_ref text not null default '',
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table purchase_orders (
 id uuid primary key default gen_random_uuid(), code text not null unique, supplier_id uuid not null references suppliers,
 currency text not null check(currency ~ '^[A-Z]{3}$'), net_cents bigint not null check(net_cents > 0),
 evidence_ref text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index po_supplier on purchase_orders(supplier_id);
create table receipts (
 id uuid primary key default gen_random_uuid(), code text not null unique, po_id uuid not null references purchase_orders,
 net_cents bigint not null check(net_cents > 0), received_on date not null, evidence_ref text not null,
 actor text not null, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index receipt_po on receipts(po_id);
create table invoices (
 id uuid primary key default gen_random_uuid(), code text not null unique, supplier_id uuid not null references suppliers,
 invoice_number text not null, po_number text not null default '', currency text not null check(currency ~ '^[A-Z]{3}$'),
 issued_on date not null, due_on date not null, net_cents bigint not null check(net_cents >= 0),
 tax_cents bigint not null check(tax_cents >= 0), gross_cents bigint not null check(gross_cents > 0),
 tax_jurisdiction text not null default 'UNKNOWN' check(tax_jurisdiction in ('NZ','OTHER','UNKNOWN')), tax_evidence text not null default '',
 description text not null default '', buyer_name text not null default '', buyer_ref text not null default '',
 source_ref text not null default '', owner text not null, entered_by text not null,
 status text not null default 'review' check(status in ('review','ready','posted','rejected')),
 reviewed_by text, review_ref text, posting_ref text,
 source_key text unique, original_data jsonb,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 check(due_on >= issued_on), check(status not in ('ready','posted') or (reviewed_by is not null and review_ref is not null)),
 check(status <> 'posted' or posting_ref is not null)
);
create index invoice_supplier on invoices(supplier_id);
create index invoice_po on invoices(po_number);
create index invoice_status_due on invoices(status,due_on);
create index invoice_duplicate on invoices(supplier_id,lower(regexp_replace(invoice_number,'[^a-zA-Z0-9]','','g')));
create table invoice_lines (
 id uuid primary key default gen_random_uuid(), invoice_id uuid not null references invoices,
 line_number integer not null check(line_number > 0), description text not null,
 net_cents bigint not null check(net_cents >= 0), unique(invoice_id,line_number),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table events (
 id uuid primary key default gen_random_uuid(), entity_id uuid not null, kind text not null, actor text not null,
 note text not null, snapshot jsonb not null, created_at timestamptz not null default now()
);
create index event_entity on events(entity_id,created_at);
create table import_batches (
 id uuid primary key default gen_random_uuid(), source text not null, file_hash text not null,
 invoice_count integer not null, actor text not null, created_at timestamptz not null default now(), unique(source,file_hash)
);
create function touch_invoice_record() returns trigger language plpgsql as $$ begin new.updated_at=now();return new;end $$;
do $$ declare n text;begin foreach n in array array['suppliers','purchase_orders','receipts','invoices','invoice_lines'] loop
 execute format('create trigger touch before update on %I for each row execute function touch_invoice_record()',n);
 end loop;end $$;
create function protect_invoice_history() returns trigger language plpgsql as $$ begin raise exception 'Append-only history';end $$;
create trigger immutable_events before update or delete on events for each row execute function protect_invoice_history();
create trigger immutable_batches before update or delete on import_batches for each row execute function protect_invoice_history();
create view invoice_register with (security_invoker=true) as
 select i.id,i.code,s.name supplier,i.invoice_number,i.currency,i.net_cents,i.tax_cents,i.gross_cents,i.po_number,i.issued_on,i.due_on,
 i.owner,i.status,i.source_ref,current_date-i.due_on overdue_days,i.reviewed_by,i.posting_ref
 from invoices i join suppliers s on s.id=i.supplier_id;
create view order_balance with (security_invoker=true) as
 select p.id,p.code,s.name supplier,p.currency,p.net_cents ordered_cents,
 coalesce((select sum(r.net_cents) from receipts r where r.po_id=p.id),0) received_cents,
 coalesce((select sum(i.net_cents) from invoices i where i.po_number=p.code and i.supplier_id=p.supplier_id and i.currency=p.currency and i.status<>'rejected'),0) invoiced_cents
 from purchase_orders p join suppliers s on s.id=p.supplier_id;
create view invoice_exceptions with (security_invoker=true) as
 select i.id,i.code,i.owner,'TOTALS' rule,'Net plus tax does not equal gross' finding from invoices i where status in ('review','ready') and net_cents+tax_cents<>gross_cents
 union all select i.id,i.code,i.owner,'SOURCE','Original invoice reference is missing' from invoices i where status in ('review','ready') and source_ref=''
 union all select i.id,i.code,i.owner,'DESCRIPTION','Supply description is missing' from invoices i where status in ('review','ready') and description=''
 union all select i.id,i.code,i.owner,'SUPPLIER','Supplier identity evidence is missing' from invoices i join suppliers s on s.id=i.supplier_id where i.status in ('review','ready') and s.verified_ref=''
 union all select i.id,i.code,i.owner,'DUPLICATE','Same supplier and normalized invoice number appears elsewhere' from invoices i where status in ('review','ready') and exists(select 1 from invoices j where j.id<>i.id and j.status<>'rejected' and j.supplier_id=i.supplier_id and lower(regexp_replace(j.invoice_number,'[^a-zA-Z0-9]','','g'))=lower(regexp_replace(i.invoice_number,'[^a-zA-Z0-9]','','g')))
 union all select i.id,i.code,i.owner,'PO','Matching supplier, currency and purchase order are missing' from invoices i where status in ('review','ready') and not exists(select 1 from purchase_orders p where p.code=i.po_number and p.supplier_id=i.supplier_id and p.currency=i.currency)
 union all select i.id,i.code,i.owner,'PO_LIMIT','Cumulative invoices exceed the order value' from invoices i join purchase_orders p on p.code=i.po_number and p.supplier_id=i.supplier_id and p.currency=i.currency join order_balance b on b.id=p.id where i.status in ('review','ready') and b.invoiced_cents>b.ordered_cents
 union all select i.id,i.code,i.owner,'RECEIPT','Cumulative invoices exceed recorded receipts' from invoices i join purchase_orders p on p.code=i.po_number and p.supplier_id=i.supplier_id and p.currency=i.currency join order_balance b on b.id=p.id where i.status in ('review','ready') and b.invoiced_cents>b.received_cents
 union all select i.id,i.code,i.owner,'LINES','Line amounts do not equal the invoice net value' from invoices i where status in ('review','ready') and exists(select 1 from invoice_lines l where l.invoice_id=i.id) and i.net_cents<>(select sum(l.net_cents) from invoice_lines l where l.invoice_id=i.id)
 union all select i.id,i.code,i.owner,'NZ_GST_NUMBER','NZ taxable supply above 200 needs supplier GST number evidence' from invoices i join suppliers s on s.id=i.supplier_id where i.status in ('review','ready') and i.tax_jurisdiction='NZ' and i.currency='NZD' and i.tax_cents>0 and i.gross_cents>20000 and s.tax_number=''
 union all select i.id,i.code,i.owner,'NZ_BUYER','NZ taxable supply above 1000 needs buyer name and identifying detail' from invoices i where status in ('review','ready') and tax_jurisdiction='NZ' and currency='NZD' and tax_cents>0 and gross_cents>100000 and (buyer_name='' or buyer_ref='')
 union all select i.id,i.code,i.owner,'TAX_SCOPE','Record tax jurisdiction and reviewer evidence for non-NZ or foreign-currency supplies' from invoices i where status in ('review','ready') and (tax_jurisdiction='UNKNOWN' or ((tax_jurisdiction='OTHER' or currency<>'NZD') and tax_evidence=''));
create view review_week with (security_invoker=true) as
 select r.*, (select count(*) from invoice_exceptions e where e.id=r.id) exception_count from invoice_register r where status in ('review','ready');
do $$ declare n text;begin foreach n in array array['suppliers','purchase_orders','receipts','invoices','invoice_lines','events','import_batches'] loop
 execute format('alter table %I enable row level security',n);execute format('revoke all on %I from public',n);
 end loop;end $$;
revoke all on invoice_register,order_balance,invoice_exceptions,review_week from public;
