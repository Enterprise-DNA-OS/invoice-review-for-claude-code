# Invoice Review for Claude Code

Run the supplier invoice review desk. Read README.md and docs/compliance.md first. Establish organisation, database, named operator and scope. One organisation per database, trusted operators only. Fictional demonstration data is never evidence about a real supplier.

Use scripts/invoice.mjs for ordinary work. Read /show before a change. An actor label is attribution, not authentication. Never invent identities, evidence or a human review. Use the operator's authorised decision. Never post to accounting, change bank details, pay an invoice, file tax or send a message.

All runtimes use the one command library in .claude/commands/. Commands are recipes, not a second executable system.

| Command | Job |
|---|---|
| /suppliers | Read supplier identities and verification references. |
| /orders | Reconcile ordered, received and invoiced amounts without mixing currencies. |
| /receipts | Read recorded delivery evidence. |
| /invoices | Read invoice totals, owners and status. |
| /review-queue | Plan today's invoice review work. |
| /attention | Read overdue invoices and their evidence gaps. |
| /exceptions | Read every unresolved review rule. |
| /receipt-gaps | Find orders billed beyond recorded goods receipt values. |
| /duplicates | Find repeated supplier invoice numbers, ignoring punctuation and case. |
| /compliance | Check recorded taxable supply evidence and arithmetic; explain the limits in docs/compliance.md. |
| /handoff-ready | Read invoices reviewed by another person and still clear of exceptions. |
| /imports | Read imported source labels, hashes and counts. |
| /show | Read a complete invoice before any action. |
| /history | Read attributed changes to an invoice. |
| /insights | Answer ten cross-record questions from current data. |
| /add-supplier | Register a supplier; verification remains a separate evidence-backed step. |
| /verify-supplier | Record an identity check from evidence supplied by the operator. |
| /add-order | Record an approved purchase order and its net value. |
| /receive | Record the value of goods actually received against one purchase order. |
| /add | Capture an invoice for review from a document the operator has checked. |
| /add-line | Record a line net amount before review. Line totals must agree with the header. |
| /amend | Correct an invoice still in review, with an explanation. Read show first. |
| /approve | Record an authorised second-person review. Never invent the reviewer or their decision. |
| /reject | Retain a duplicate or invalid invoice with a documented rejection. |
| /record-posting | Record an accounting reference supplied by finance after posting in their accounting system. This does not post or pay. |
| /log | Append a note without rewriting earlier history. |
| /import | Read docs/replace-rossum.md, confirm source organisation, mapping and owner, then preview the import. Present counts and exceptions before applying the same command without --dry-run. |
| /export | Export all records and history to a new file. Never overwrite an existing export. |
| /draft-query | Draft an invoice evidence request from recorded exceptions. Read the document yourself. Nothing sends. |
| /capture-invoice | Read an invoice with the agent and a human check. |
| /weekly-review | Monday review from three current reads. |
| /customise | Change the system through a tested migration. |
| /new-view | Add a read-only report. |

Keep drafts in drafts/. A receipt is net value received, not payment. Matching is at document-total level, not SKU or quantity-level three-way matching. Do not call an empty exception list legal compliance. Sources are evidence references, not copies of the original invoices. Retain originals securely and use tested database backups.

Do not delete records, edit applied migrations or seed a business database. Use /customise for an authorised structural change. Do not bypass review gates with direct SQL. Never store bank credentials. Back up and isolate each organisation before shared deployment.

Omni by Enterprise DNA installs and runs the system: https://enterprisedna.co/omni/book?offer=replace-software&utm_campaign=rossum
