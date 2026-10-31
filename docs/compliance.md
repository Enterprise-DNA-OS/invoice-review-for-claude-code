# Evidence checks and their limits

Checked 2026-10-31. This is a record review tool, not a tax calculation, filing, payment or legal certification service. A reviewer must read the original evidence. Amounts are recorded in cents; matching is by supplier, order and currency. No tax rates or exchange rates are inferred.

| Rule | Check and source |
|---|---|
| NZ_GST_NUMBER | For explicitly designated NZ supplies in NZD with positive recorded GST and gross above NZD 200, flag a missing supplier GST number. This only checks presence, not registration or validity. |
| NZ_BUYER | For the same scope above NZD 1,000, flag missing buyer name or identifying detail. This desk assumes a GST-registered business buyer; its evidence policy is conservative for other buyers. |
| TAX_SCOPE | Unknown jurisdiction is blocked. OTHER or foreign-currency supplies need an accountant review reference. This is our operating policy, not a statutory threshold. |
| SOURCE, DESCRIPTION, TOTALS | Require the original evidence reference and description; compare recorded net plus tax with gross. These support record review and are not proof of tax treatment. |
| SUPPLIER, PO, PO_LIMIT, RECEIPT, DUPLICATE, LINES | Internal purchasing controls: identity evidence, matching order, cumulative order/receipt caps, repeated invoice numbers and line-net reconciliation. These are local policies, not legislation. |

[IRD: taxable supply information](https://www.ird.govt.nz/gst/tax-invoices-for-gst/how-tax-invoices-for-gst-work) explains the evidence fields and value bands. Multiple documents can support a supply. The base covers ordinary positive-GST invoice records only. Zero-rated, exempt, secondhand, buyer-created, mixed, foreign-currency and credit cases need the accountant's own review. It neither tests GST eligibility nor verifies every statutory requirement.

[IRD: record keeping](https://www.ird.govt.nz/managing-my-tax/record-keeping) requires retention for at least seven tax years and sets language and offshore-storage conditions. This system has no automatic deletion and retains source rows and review history, but does not store original files or guarantee retention. Set secure archive, hosting location, access and tested backups with the accountant before real use.

[Privacy principle 5](https://www.privacy.org.nz/privacy-principles/5/) informs restricted files and database access. [Principle 8](https://www.privacy.org.nz/privacy-principles/8/) informs checking records before use. Actor names are not authentication. A database administrator can alter controls, so use trusted operators and external access controls. RLS is enabled with no public policies; shared deployments need explicitly scoped roles. No online account, bank, government portal or customer system is accessed.
