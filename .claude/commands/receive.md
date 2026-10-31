# receive

Record the value of goods actually received against one purchase order.

Run `node scripts/invoice.mjs receive --code=<code> --po=<code> --net=<amount> --date=YYYY-MM-DD --evidence=<reference> --actor=<operator>`. Quote each complete flag when its value contains spaces. Use `--json` for exact values.

Read current evidence first. Never invent an amount, document reference, person or decision. Keep currencies separate. Explain missing evidence as unknown. Report the invoice code, result and next recorded owner. Drafts stay local. No emails, payments or accounting writes.
