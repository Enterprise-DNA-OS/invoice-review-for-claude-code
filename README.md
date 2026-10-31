<h1 align="center">Invoice Review for Claude Code</h1>

<p align="center">
  <strong>The open-source invoice review desk that is just a database and Claude Code.</strong>
</p>

<p align="center">
  Created by <a href="https://www.enterprisedna.co"><strong>Enterprise DNA</strong></a>. Free and open source. Works with Claude Code, Codex, OpenCode or Cursor.
</p>

<!-- three-doors -->
<table align="center">
  <tr>
    <td align="center"><strong>Do it yourself</strong><br/>Clone it, run it, own it. Free, MIT.<br/><a href="#quick-start">Quick start</a></td>
    <td align="center"><strong>We customise it</strong><br/>Your fields, your rules, your Rossum data brought across.<br/><a href="https://enterprisedna.co/omni/book/?utm_source=github&utm_medium=readme&utm_campaign=rossum">Book a call</a></td>
    <td align="center"><strong>We run it for you</strong><br/>Installed, connected and operated inside Omni. Setup fee, then a retainer.<br/><a href="https://enterprisedna.co/omni/instead-of/rossum?utm_source=github&utm_medium=readme&utm_campaign=rossum">How it works</a></td>
  </tr>
</table>


## What is this

Invoice Review for Claude Code holds captured supplier invoices, purchase orders, receipt values, exceptions and review history in a database you own. Ask the agent what needs attention, reconcile the evidence and produce a draft accounting handoff. Omni by Enterprise DNA installs, customises and runs it for a setup fee and then a retainer.

Rossum's [own pricing](https://rossum.ai/pricing/) starts at $18,000 per year, with currency not stated on the visible page, checked 2026-10-31. This rebuild covers invoice review. Rossum also supplies document extraction, validation screens, document archives and integrations. This free base has a supervised /capture-invoice workflow, not a bundled OCR service or an unattended mailbox. It never posts to accounting, moves money or files tax.

## Quick start

```bash
npm install
npm run demo
node scripts/invoice.mjs attention
node scripts/invoice.mjs insights
npm run view
npm run docs
npm test
```

Node 20 or newer. PGlite runs locally without a database install. Demo data is fictional. Open this folder in Claude Code, Codex, OpenCode or Cursor and start with /review-queue. AGENTS.md points every runtime at the same command library.

For your own database, set DATABASE_URL in your environment, run npm run migrate and register your records. The same migration and CLI use standard PostgreSQL. Seed refuses DATABASE_URL and refuses an already-operated demo. Keep a separate database per organisation. Amount flags are decimal currency units; machine and table outputs use explicitly labelled integer cents. Calendar dates stay in YYYY-MM-DD form.

## The commands

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

Every CLI command supports --json. Codes match without case sensitivity; partial UUIDs, partial codes and supplier names work when unambiguous. Ambiguous references list candidates and exit 1. Every change needs a named actor and records history. Actor names are attribution, not identity verification.

## Instead of Rossum

Bring a UTF-8 CSV export from Rossum through one import command. [The switching guide](docs/replace-rossum.md) explains configurable headings, line grouping, source IDs, missing evidence and safe preview. Original rows are retained, batches are atomic, and imports begin in review. PDFs and extraction models do not transfer through CSV.

```bash
node scripts/invoice.mjs import rossum examples/rossum-invoices.csv --source=demo-export --owner=Finance --actor=Operator --jurisdiction=NZ --dry-run
node scripts/invoice.mjs export --out=invoice-records.json
```

## Controls that do work today

Supplier and currency must match the order. Cumulative invoice net values cannot exceed order or recorded receipt values. Repeated supplier invoice numbers, mismatched totals, missing original references and missing review evidence block handoff. Receipt matching is at document-total level, not SKU or quantity-level three-way matching. The second reviewer must differ from the intake actor. Handoff checks run again after review, so a newly arrived duplicate blocks it. Rejected documents remain in history.

The /compliance checks cover a defined subset of NZ taxable-supply evidence plus local operating controls. Read [the sources and limits](docs/compliance.md). A clear result is not tax approval. Other jurisdictions and foreign-currency supplies need an accountant reference. Credits, tax returns, exchange conversion, bank records and payments are outside this base.

## Ten questions to ask

The insights command answers all ten from current records. These are included cross-record reports, not a claim that Rossum cannot provide equivalent custom reports.

1. Which overdue invoices have missing receipt evidence?
2. Which supplier invoice numbers appear more than once?
3. Which owners have the most exceptions?
4. Which orders have more invoices than received goods?
5. Which invoices exceed the total authorised order?
6. Which records lack their original invoice reference?
7. Which NZ taxable supply records need more evidence?
8. Which invoices disagree with their line amounts?
9. Which suppliers have the longest overdue invoices?
10. Which reviewed invoices are still clear for handoff?

## Documents and views

npm run docs generates branded invoice review packs and draft accounting handoffs for clear, reviewed records. npm run view generates the week, receipt balances and evidence gaps. /draft-query creates an internal evidence request in drafts/. Nothing sends. Change business name, colours and logo in brand.json. Views and documents are static, read-only HTML snapshots. [Why no front end](docs/why-no-front-end.md) explains where a capture screen is useful.

## Your first hour: ten things to ask for

1. Put our name and colours on review packs.
2. Add our suppliers and their verification references.
3. Record three purchase orders with their currencies.
4. Record the goods receipt value and evidence for each.
5. Preview a small Rossum export and compare totals.
6. Show duplicated invoice numbers across import sources.
7. Show what is overdue for each owner.
8. Capture a new invoice and ask another person to review it.
9. Produce a draft accounting handoff for the reviewed record.
10. Add our cost-centre field with /customise and a tested migration.

## Access, records and verification

Use trusted operators with a separate database per organisation. All domain tables have RLS enabled and no public access policies. Protect owner credentials; a database owner can bypass application controls. History rejects ordinary updates and deletes but is not tamper-proof against an administrator. Secure original files separately and test native database backups. JSON export is a portable record copy, not a restore system. CSV protects spreadsheet formula prefixes. HTML escapes record text. No original documents, secrets or real customer data ship in this repository.

npm test uses disposable storage and checks all 29 CLI commands. The manual CI workflow runs Linux and Windows plus PostgreSQL 17. Actual results are in docs/verification.md. No database extensions are required.

MIT. Rossum is its owner's trademark. This project is independent of Rossum.
