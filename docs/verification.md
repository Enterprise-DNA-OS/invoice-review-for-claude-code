# Verification

Checked 2026-10-31.

- Linux, Node 20 and Node 22.23.4, PGlite: npm test PASS, 83 assertions covering all 29 CLI commands.
- Linux, PostgreSQL 17.11: the same smoke suite PASS, 83 assertions. A disposable local server was started for this check and stopped afterwards. No live database or credentials were used.
- npm install, npm run demo, npm run view and npm run docs PASS. Branded review pack, weekly report and a reviewed accounting handoff were opened headlessly and visually inspected.
- 33 operator commands ship in .claude/commands, including capture-invoice, weekly-review, customise and new-view.
- The exact shared Landing Pages route was built in a temporary focused preview, restricted to this target. All three captured CLI outputs render as tables, their tabs work, booking links include the target and offer, and the page has noindex,nofollow. Desktop and 390-pixel mobile screenshots were inspected; no page-width overflow. This was a target-page build, not a full-site build.
- The page gate passed with zero brand errors and three sourced price mentions. The page was pushed to Landing Pages main in commit 9266f855.
- Windows and hosted CI checks did not start. GitHub returned an account billing/spending restriction, not a code failure: https://github.com/Enterprise-DNA-OS/invoice-review-for-claude-code/actions/runs/41247382011. The manual Linux/Windows/PostgreSQL workflow remains ready to rerun when that restriction is resolved. Windows execution is unverified.

No real customer records were used. No publication, message, payment, campaign update or customer-system write was performed. The private repo and noindex page are handed to the nightly runner for its own publication step.
