# record-posting

Record an accounting reference supplied by finance after posting in their accounting system. This does not post or pay.

Run `node scripts/invoice.mjs record-posting <invoice> --reference=<accounting-reference> --note=<confirmation> --actor=<operator>`. Quote each complete flag when its value contains spaces. Use `--json` for exact values.

Read current evidence first. Never invent an amount, document reference, person or decision. Keep currencies separate. Explain missing evidence as unknown. Report the invoice code, result and next recorded owner. Drafts stay local. No emails, payments or accounting writes.
