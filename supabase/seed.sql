insert into suppliers(id,code,name,tax_number,verified_ref) values
 ('10000000-0000-0000-0000-000000000001','SOUTH','South Quay Packaging','111-111-111','demo/supplier-check-01'),
 ('10000000-0000-0000-0000-000000000002','RIDGE','Ridge Office Supply','222-222-222','demo/supplier-check-02'),
 ('10000000-0000-0000-0000-000000000003','BAY','Bay Components','','') on conflict do nothing;
insert into purchase_orders(id,code,supplier_id,currency,net_cents,evidence_ref) values
 ('20000000-0000-0000-0000-000000000001','PO-100','10000000-0000-0000-0000-000000000001','NZD',500000,'demo/order-100'),
 ('20000000-0000-0000-0000-000000000002','PO-200','10000000-0000-0000-0000-000000000002','NZD',100000,'demo/order-200'),
 ('20000000-0000-0000-0000-000000000003','PO-300','10000000-0000-0000-0000-000000000003','AUD',80000,'demo/order-300') on conflict do nothing;
insert into receipts(code,po_id,net_cents,received_on,evidence_ref,actor) values
 ('GR-100','20000000-0000-0000-0000-000000000001',500000,current_date-10,'demo/delivery-100','Demo receiving'),
 ('GR-200','20000000-0000-0000-0000-000000000002',50000,current_date-8,'demo/delivery-200','Demo receiving') on conflict do nothing;
insert into invoices(id,code,supplier_id,invoice_number,po_number,currency,issued_on,due_on,net_cents,tax_cents,gross_cents,description,buyer_name,buyer_ref,source_ref,owner,entered_by) values
 ('30000000-0000-0000-0000-000000000001','INV-101','10000000-0000-0000-0000-000000000001','SQ-1001','PO-100','NZD',current_date-20,current_date+5,200000,30000,230000,'Packaging cartons','Harbour Demo Ltd','demo/buyer','demo/invoice-101','Mara','Demo intake'),
 ('30000000-0000-0000-0000-000000000002','INV-102','10000000-0000-0000-0000-000000000002','R-2002','PO-200','NZD',current_date-40,current_date-10,70000,10500,80500,'Office stationery','Harbour Demo Ltd','demo/buyer','demo/invoice-102','Leo','Demo intake'),
 ('30000000-0000-0000-0000-000000000003','INV-103','10000000-0000-0000-0000-000000000003','B-3003','','AUD',current_date-25,current_date-4,60000,6000,66000,'Replacement components','','','','Mara','Demo intake'),
 ('30000000-0000-0000-0000-000000000004','INV-104','10000000-0000-0000-0000-000000000001','sq1001','PO-100','NZD',current_date-20,current_date+5,200000,30000,230000,'Packaging cartons','Harbour Demo Ltd','demo/buyer','demo/invoice-104','Leo','Demo intake'),
 ('30000000-0000-0000-0000-000000000005','INV-105','10000000-0000-0000-0000-000000000001','SQ-1005','PO-100','NZD',current_date-10,current_date+15,50000,7500,57500,'Packing tape','Harbour Demo Ltd','demo/buyer','demo/invoice-105','Mara','Demo intake') on conflict do nothing;
insert into invoice_lines(invoice_id,line_number,description,net_cents) values
 ('30000000-0000-0000-0000-000000000005',1,'Packing tape',50000) on conflict do nothing;

update invoices set tax_jurisdiction=case when currency='NZD' then 'NZ' else 'OTHER' end,tax_evidence=case when currency='AUD' then 'demo/au-accountant-review' else '' end where code like 'INV-10%';
