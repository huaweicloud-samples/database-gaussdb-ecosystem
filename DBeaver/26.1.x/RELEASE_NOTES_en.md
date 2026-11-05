# DBeaver 26.1.5 GaussDB Enhanced Edition Release Notes

Application build: `26.1.5.20261105r1`; delivery revision: `20261105-r2`; updated on 2026-11-05. R2 updates the connection manual to V1.9 and delivers the complete enhanced source. Java plug-ins retain the R1 build; the archives, manual, source and checksums identify this delivery revision.

Release tag: `dbeaver-gaussdb-26.1.5-kylin-x86_64-20261105-r2`

## Assets

This delivery includes the Kylin V10 x86_64 client, product manifest, complete enhanced source, and standalone Word manual:

| File | Purpose | SHA-256 |
| --- | --- | --- |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261105-r2.tar.gz` | Client archive | `e35365c5c3af67ab8a73e63b7aaf73287b09df60caf82d7526e2ba079730c8c5` |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261105-r2.PRODUCT-MANIFEST.json` | Package file manifest | `ec5727fd83c39d0dff7200f794e20a50c6b88ea91fda2a1c9119e51d4ecbb90d` |
| `dbeaver-gaussdb-enhanced-source-20261105-r2.tar.gz` | Enhanced source, matching dbeaver-common, and internal hash manifest | `8ea7e6e10dfba5e7291a4b6983792747a2bacd9e99fa7abf93c99bea45d4ce9f` |
| `GaussDB_DBeaver_调试与Package操作手册_20261105.docx` | V1.9 connection, debugging, and Package operation manual | `9341e530517a9a6eb2cefa01b0db257fa2e7782be7e8347089919727fb2f0780` |
| `SHA256SUMS` | Checksum entry point for the four payload files above | Generated and read back during publication |

## Highlights

- GaussDB compatibility-mode detection and capability gating.
- Stored procedure and function breakpoints, stepping, resume, and termination.
- Breakpoint management, variable inspection and modification, watches, and call stacks.
- `refcursor` / `sys_refcursor` state summaries, read-only attributes, and attribute watches.
- Commit or rollback selection for debug transactions.
- Package specification, body, and full compilation, error navigation, and batch deletion.
- Simplified Chinese resources and an illustrated operation manual.

## Repairs and validation in this build

- 2026-11-05 R2 is a delivery revision: V1.9 adds illustrated first-connection, JDBC configuration, and result-checking steps, with a standalone Word manual. Java plug-ins retain application build `26.1.5.20261105r1`.
- The ecosystem Release now provides an explicitly named enhanced-source archive containing the final DBeaver source, official dbeaver-common commit `2df03e58480c6325732f476e8355e375cec5405e`, and an internal `SOURCE-MANIFEST.json`. GitHub's default Source code links still archive the ecosystem documentation tree.
- Connection-walkthrough validation: A translated Kylin V10 x86_64 container connected to centralized 507 ORA using a fresh connection wizard, the native driver and a local JDBC jar; field entry, authentication without saved password, successful connection test, saved navigation, SQL queries confirming Kernel 507/current database/user/sql_compatibility=A, and the Error Log view were exercised. Thirteen complete-window screenshots were captured. The revised Word manual has 43 pages and 24 images, all visually checked. The R1 full-regression and product-build results below are existing records, not new R2 runs.

The R2 archive was freshly extracted and passed all 1202 application inventory entries, identical to R1. Its Word document and 24 images match the committed files. The extracted enhanced-source archive passed all 10841 file/link records. The source parent project also passed nonrecursive Maven validate without Git metadata; this is not a new complete product build. Five documentation packaging checks passed.

The following repairs and validation belong to the 2026-11-05 R1 application build:

- 2026-11-05 R1: Resolve the actual parameter type OID and qualify user-defined types with their owning schema, fixing cross-schema composite calls that failed because the schema was missing. Built-in type formatting is preserved.
- 2026-11-05 R1: The completion dialog explicitly applies Commit/Rollback only to the remaining transaction. Commits already executed by the routine cannot be undone; this choice does not save source code and defaults to Rollback.
- Main regression: 3,137 cases, with 2,953 passed, 184 conditionally skipped, zero failures or errors; seven cases were added since R6.
- Centralized 507 ORA GUI: a translated Kylin V10 x86_64 container sharing the LinuxKit kernel debugged `(1,张三)` and `(2,"Alice, Jr.")`, paused, and displayed their fields. An actual commit was verified from an independent connection.
- SQL NULL and internal-COMMIT verification: A whole-object SQL NULL argument launched and completed successfully; an independent connection confirmed one committed row for each composite example and one SQL NULL row. On 507, `info_locals()` can display NULL composite fields as `0/<UNKNOWN>`; these placeholders are not claimed as exact field values. The internal-COMMIT scenario inserted 901 and committed, then inserted 902. Final rollback preserved 901, removed the uncommitted 902, and left no live debug target or process.

- Final product: all 204 build modules succeeded; fresh extraction passed all 1202 inventory entries, and 6 key production plugins byte-match the tested GUI copy.

The following R6 and earlier results are historical records; their complete suites were not rerun for this build:

- R6: Display cursor information already supplied by `info_locals()` as a state summary and read-only `%ISOPEN`, `%FOUND`, `%NOTFOUND`, and `%ROWCOUNT` children; show `NAME` when available and `PACKAGE` for Package cursors. Equal cursor names from different packages are preserved in the frame, and an unqualified attribute watch reports ambiguity. Watches support the cursor variable and attributes such as `cur%ROWCOUNT`.
- R6: Match older hidden attributes by complete cursor name, Package, and call frame, avoiding prefix collisions and cross-scope values. Preserve missing, invalid, duplicate, or conflicting protocol data rather than inventing state. The cursor and children cannot be edited; no additional FETCH, query rerun, or private setting is introduced.
- R6: Retain stable variable and child snapshot identities. Suspension only creates missing debug views without activating them, so Breakpoints no longer hides Expressions and stops its refresh.
- R6 main regression: 3,130 cases, with 2,946 passed, 184 conditionally skipped, zero failures or errors; this build adds 87 regression cases.
- R6 live protocol checks: centralized 507 ORA; 86 assertions per round, repeated twice with both rounds passing. The older name-based hidden format is unit-tested with supplied protocol fixtures; no new 505-server validation of that format is claimed.
- R6 product build and GUI acceptance: All 204 Maven modules built successfully. The final R6 GUI ran in a translated Kylin V10 x86_64 container with a fresh workspace connected to centralized 507 ORA. The real Variables and Expressions views refreshed the cursor and cur%ROWCOUNT watch after OPEN, the first and second FETCH, exhaustion with NOTFOUND, and CLOSE. Both views expanded all four state attributes and NAME with read-only protection. The selected frame, source caret, and execution annotation aligned at line 10. F9 completed normally; rollback left no live debug target or process, and the client exited normally. The six production bundles match the final GUI copy byte for byte; the extracted archive passed all 1,202 manifest entries. Same-frame cursor isolation and ambiguity across Packages are unit-tested; this combination is not claimed as GUI-validated.

The R5, R4, R3, and R2 entries below are historical records; their complete suites were not rerun with R6:

- R5: Synchronize target and thread states across continue, stepping and completion. Clear stale stack frames when running and refresh them at the next suspension. Disable Resume while commit/rollback is pending; outdated resume requests no longer change the completed session state.
- R5: Fix premature completion when a Package child routine END returns `[EXECUTION FINISHED]`. Match the marker exactly and check the backtrace on the same controller connection for a remaining pause, without relying on OIDs to distinguish call levels. Confirm completion only after the target CALL returns successfully; accept only the expected `D0005` completion state and preserve other errors. This server behavior was confirmed by an independent live-507 JDBC protocol probe and R5 client GUI acceptance.
- R5: Match error markers exactly to prevent false failures from source strings and comments. Genuine server error markers still terminate the debug session and report the error.
- R5 adds 45 regression cases (19 model-state and race cases, and 26 completion/error-marker cases). The main suite contains 3,043 cases: 2,859 passed, 184 conditionally skipped, zero failures or errors. The R4, R3 and R2 GUI checks below are historical records and were not rerun with R5.
- R5 live GUI: a translated Kylin V10 x86_64 container connected to centralized 507 ORA. Stepping through a three-level Package call crossed the server-reported child line 0, returned to the parent and completed normally; another run continued successfully from child line 0. Resume and stepping were disabled during transaction completion. An independent connection read one row after commit, then still one after another debug run rolled back.
- R5 built all 204 product modules. The six production bundles involved in the repair are byte-identical to the GUI acceptance copy.

- R4: The database debug type is offered only in Debug Configurations, avoiding `No tab group defined` when creating an entry in Run Configurations. The generic Run Configurations menu remains available for other launch types; ordinary SQL runs in the SQL editor.
- R4: A single click selects a breakpoint; double-click to open source at its line. Switching view tabs does not automatically open source.
- R4: Initial or slow source loading completes before breakpoint-line positioning. Double-clicking a breakpoint also returns an existing object editor from Properties to Source while preserving unsaved source changes.
- Historical R4 regression: 29 cases were added; the main suite contained 2,998 cases, with 2,814 passed, 184 conditionally skipped, zero failures or errors.
- R4 built all 204 product modules; the extracted archive passed manifest verification for 1,202 entries. Live GUI checks cover selection without opening, double-click and Go to File navigation, Properties-to-Source routing, an eight-second loading delay and no reopening after close. An actual Package debug launch aligns the paused line, caret and execution annotation, then completes with rollback.
- R3: Repeating Package member debugging requests a new acknowledgement for its transaction-scoped setting. An otherwise valid configuration can launch with the checkbox unchecked and ask for confirmation then; declining cancels the launch.
- R3: Closing a source tab or switching views invalidates pending source lookup, preventing outdated callbacks from reopening tabs or taking focus back.
- R3 adds 69 regression cases and live GUI checks for execution positions, double-click reopening, per-launch confirmation and stable source close/view switching.
- R3: Incomplete connection initialization produces a clear status message instead of a launch null-pointer failure.
- R3: Connection identities are preserved in custom breakpoint labels. Historical workspace breakpoints remain configured; matching duplicate records can be removed without clearing unrelated connections.
- R2: Package member selection, cold source navigation, stable breakpoint identity and removal of all matching duplicates; connection identities in breakpoint labels.
- R2 adds 23 regression cases and live GUI checks for three Package frames, variables, source, stepping and commit/rollback data results.
- Fix JDBC driver concurrency failures during parallel multi-schema metadata loading.
- Fix M-mode SESSION_USER connection initialization errors.
- Include the debug parameter panel layoutData null-pointer repair and guidance for stale routine OIDs.
- R3 built all 204 product modules; its main regression had 2,785 passed, 184 skipped, zero failures or errors.
- Previously completed in R2: two drivers each passed three multi-schema refresh rounds of 500 tasks; M-mode data reading and parameter panel creation passed.
- R4 and R3 used a translated Kylin V10 x86_64 container and centralized 507 ORA server; R2 previously checked the 505 JDBC driver. The full historical 505 server suite was not rerun. See the usage guide for validation boundaries.

## Boundaries

- ARM64 and Windows packages are not included in this release.
- Composite-argument GUI coverage is limited to the listed examples, not all object, array, or domain types. The translated container shares the LinuxKit kernel and does not constitute native x86 hardware acceptance.
- Locally rebuilt Linux native libraries in the package are not digitally signed; use SHA-256 and the product manifest for integrity verification.
- The x86_64 GUI check used a Kylin V10 x86_64 user space with host instruction translation; it does not replace final target-device or virtual-desktop admission testing.
- The GaussDB JDBC driver and native database tools are not bundled.
- M compatibility mode is supported for basic database use; PL/SQL debugging is not claimed for M mode.
- Complete Package compilation and error navigation depend on the target deployment and server capabilities.
- Paused cursor inspection shows state only. Result rows, original SQL, and column-structure previews require a future server interface. Current live checks cover the 507 inline format; the older name-based hidden format has protocol-fixture unit coverage only.

See the [usage guide](./README_en.md) for installation and operating instructions.
