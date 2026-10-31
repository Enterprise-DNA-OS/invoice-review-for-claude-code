# Replace the invoice review workflow in Rossum

Source checked 2026-10-31: [Rossum export guide](https://knowledge-base.rossum.ai/help/docs/exporting-captured-data) and [API guide](https://rossum.app/api/docs/openapi/guides/getting-started/).

1. In Rossum, use Download all from the Exported tab for a copy that keeps documents in that tab. Export from Confirmed moves those documents to Exported; make that workflow choice deliberately. Filter the date range and download CSV in UTF-8 with comma separators.
2. Keep original files separately. Inventory exported queues and dates. Include Vendor ID, Vendor name, Invoice number, Invoice Date, Due date, PO Number, Currency, Total amount, Total without tax and Total tax. Column labels are configurable. Include Document ID for a stable document identifier, especially duplicate invoice numbers, and Document URL or Source reference when available. For line exports include Line number, Item description and Item total. Repeated header values must agree. The example is synthetic, not an actual customer export.
3. Register and verify your suppliers and record purchase orders and goods receipt values. Imports can create unverified suppliers, which remain blocked until checked. The free importer brings captured invoice data across; it does not copy Rossum's extraction models, PDFs, mailbox, automation, roles or integrations.
4. Run the preview, reconcile the counts and values, then apply it:

```bash
node scripts/invoice.mjs import rossum examples/rossum-invoices.csv --source=demo-export --owner=Finance --actor=Operator --jurisdiction=NZ --dry-run
node scripts/invoice.mjs import rossum examples/rossum-invoices.csv --source=demo-export --owner=Finance --actor=Operator --jurisdiction=NZ
node scripts/invoice.mjs exceptions
```

Use a stable source label for each organisation and queue. Use `--map=examples/column-map.json` to map custom labels to the import's canonical keys. Supply `--currency=NZD` only after checking the entire file uses that currency. Currency is never guessed. If net is absent, gross minus the explicitly supplied tax is used. Missing tax is rejected, not treated as zero. Dates must be ISO calendar dates. Credit notes and negative amounts are rejected; preserve them separately and agree a credit workflow before switching.

Choose `--jurisdiction=NZ` only for NZ supplies; otherwise leave UNKNOWN pending review or choose OTHER with `--tax-evidence=<accountant-reference>`. Foreign-currency NZ supplies also need that evidence. The base does not convert currencies. Existing invoices can be amended while in review.

Each row retains its original fields. Each invoice starts in review, regardless of the source's status. The whole batch commits or rolls back. Identical files from the same source do nothing. A changed or overlapping source record is rejected for explicit reconciliation; do not change the source label to force it through. Check duplicate invoice numbers across sources. An export containing the same header twice without line detail needs Document ID to distinguish the records.

Validate a small batch, reconcile currency totals, compare original files, test a duplicate and a missing receipt, and walk one record through review and accounting handoff before deciding to cancel Rossum. Keep your document capture and accounting systems running until the replacement workflow is proven. Enterprise DNA maps custom exports and connects capture in the installed version.
