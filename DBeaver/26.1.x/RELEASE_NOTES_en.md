# DBeaver 26.1.5 GaussDB Enhanced Edition Release Notes

Build: `26.1.5.20261102r4`; updated on 2026-11-02. The release tag, archive, product manifest and checksums all identify this build.

Release tag: `dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r4`

## Assets

This release contains only the Kylin V10 x86_64 edition:

| File | Purpose | SHA-256 |
| --- | --- | --- |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r4.tar.gz` | Client archive | `ddeeb034de4024ae2ac7cee078bb16a9d9c996329d488eedf9cdc74a8f660773` |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r4.PRODUCT-MANIFEST.json` | Package file manifest | `1b680f84f491e6cb0f3132530857253abcc0814f975dbb0439030abfca9331b7` |
| `SHA256SUMS` | Checksum entry point for the two payload files above | Generated and read back during publication |

## Highlights

- GaussDB compatibility-mode detection and capability gating.
- Stored procedure and function breakpoints, stepping, resume, and termination.
- Breakpoint management, variable inspection and modification, watches, and call stacks.
- Commit or rollback selection for debug transactions.
- Package specification, body, and full compilation, error navigation, and batch deletion.
- Simplified Chinese resources and an illustrated operation manual.

## Repairs and validation in this build

- R4: The database debug type is offered only in Debug Configurations, avoiding `No tab group defined` when creating an entry in Run Configurations. The generic Run Configurations menu remains available for other launch types; ordinary SQL runs in the SQL editor.
- R4: A single click selects a breakpoint; double-click to open source at its line. Switching view tabs does not automatically open source.
- R4: Initial or slow source loading completes before breakpoint-line positioning. Double-clicking a breakpoint also returns an existing object editor from Properties to Source while preserving unsaved source changes.
- R4 adds 29 regression cases. The main suite contains 2,998 cases: 2,814 passed, 184 conditionally skipped, zero failures or errors.
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
- Locally rebuilt Linux native libraries in the package are not digitally signed; use SHA-256 and the product manifest for integrity verification.
- The x86_64 GUI check used a Kylin V10 x86_64 user space with host instruction translation; it does not replace final target-device or virtual-desktop admission testing.
- The GaussDB JDBC driver and native database tools are not bundled.
- M compatibility mode is supported for basic database use; PL/SQL debugging is not claimed for M mode.
- Complete Package compilation and error navigation depend on the target deployment and server capabilities.

See the [usage guide](./README_en.md) for installation and operating instructions.
