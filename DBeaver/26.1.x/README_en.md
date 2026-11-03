# DBeaver 26.1.5 GaussDB Enhanced Edition Guide

Build: `26.1.5.20261103r6`; updated on 2026-11-03. The release tag, archive, product manifest and checksums all identify this build.

## 1. Overview

This edition is based on the official DBeaver 26.1.5 source tree and its GaussDB core plug-in. It extends DBeaver for GaussDB application development, stored routine debugging, and Package management.

It reuses the official DBeaver object model, SQL editor, Eclipse RCP platform, and generic debug framework, and adds:

- GaussDB compatibility-mode detection and capability-based feature gating.
- Breakpoint debugging for stored procedures and functions.
- Step Into (F7), Step Over (F8), Step Return (Shift+F7), Resume (F9), and Terminate (F10).
- Breakpoint creation, enable/disable, deletion, and centralized management.
- Local variable inspection and modification, watches, call stacks, and source navigation.
- `refcursor` / `sys_refcursor` state summaries, read-only attributes, and attribute watches.
- Commit or rollback selection when a debug session finishes.
- Package specification, body, and full compilation, compile-error navigation, and batch deletion.

Source baselines:

- [DBeaver GaussDB enhanced source tag](https://github.com/jarrenL/dbeaver/tree/gaussdb-2615-x86_64-beta-20261103-r6)
- Source revision: `590b4395c1c512257b95248a6d1bd26415f4c644`
- [Independent test project](https://github.com/jarrenL/gaussdb-dbeaver-tests)
- Test revision: `96690286a163c0f3898fab3d3877098520384f3d`

## 2. Scope

| Item | Current release scope |
| --- | --- |
| Client version | DBeaver 26.1.5 GaussDB Enhanced Edition |
| Client platform | Kylin V10 x86_64 |
| Validated database | Historical baseline: centralized and distributed GaussDB 505.2.1.SPC0800; this cursor-state enhancement: centralized GaussDB 507 ORA; see section 8 for the validation scope |
| Compatibility modes | Detects ORA/A, MYSQL/B, TD/C, PG, and M; features are enabled according to server capabilities |
| PL/SQL debugging | Enabled when the server provides the required `DBE_PLDEBUGGER` signatures and the current user has permission |
| Package management | Full capability is intended for Package-capable centralized ORA deployments; other deployments use capability-based fallback behavior |

M compatibility mode supports connections, object browsing, and basic SQL operations. This release does not claim PL/SQL debugging support for M mode. The client checks compatibility mode, routine language, debug API signatures, and permissions before starting a session and displays an explicit reason when a requirement is not met.

## 3. Download and integrity verification

The ecosystem release currently contains only the recently validated Kylin V10 x86_64 client:

- [Release page](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/tag/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261103-r6)
- [dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261103-r6.tar.gz](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261103-r6/dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261103-r6.tar.gz)
- [Product manifest](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261103-r6/dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261103-r6.PRODUCT-MANIFEST.json)
- [SHA256SUMS](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261103-r6/SHA256SUMS)

SHA-256:

```text
b5e1492025d1c414bb71d69d8bf09aa34297b4d6875472a0ca674213b6df1a7c  dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261103-r6.tar.gz
```

Verify the download and architecture:

```bash
sha256sum dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261103-r6.tar.gz
uname -m
```

`uname -m` must report `x86_64`, and the digest must match the value above. This package cannot run on ARM64/aarch64 systems.

## 4. Installation and startup

The release is a portable archive with a bundled Java 21 runtime. Extract it into a new directory instead of overwriting an active installation.

```bash
tar -xzf dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261103-r6.tar.gz
cd dbeaver
./dbeaver
```

If the launcher is not executable:

```bash
chmod +x dbeaver
./dbeaver
```

To force Simplified Chinese at startup:

```bash
./dbeaver -nl zh
```

![Simplified Chinese configuration](./imgs/language-config.png)

After the main window closes, background processes may need several seconds to save and release the workspace. Wait for the previous process to exit before starting another instance, or DBeaver may report `Can't lock workspace`.

## 5. Configure the GaussDB JDBC driver

The distribution does not bundle a GaussDB JDBC driver. Use an organization-approved driver that matches the target database version:

1. Start DBeaver and select **Database** > **Driver Manager**.
2. Select `GaussDB` and choose **Edit**.
3. Add the GaussDB JDBC JAR on the **Libraries** page.
4. Confirm that the driver class is the GaussDB JDBC class supplied by that package.
5. Create a connection and enter the host, port, database, user, and password.
6. Run **Test Connection** and confirm the server version, compatibility mode, and user.

The client does not silently alter private session parameters. If a server capability requires an additional parameter, the capability check or server error reports it explicitly so that a user or database administrator can review and set it deliberately.

Built-in GaussDB drivers disable “Thread safe driver” by default, serializing statements and result reading on each connection to avoid driver concurrency failures during multi-schema refresh. Separate connections remain parallel. If an old workspace or custom driver explicitly enables this option, disable it in Database → Driver Manager → Edit and reconnect. This is a client setting and does not alter database session parameters.

## 6. Debug a stored procedure or function

### 6.1 Start a debug session

1. In **Database Navigator**, expand the database, schema, and **Procedures** or **Functions** node.
2. Open the routine and save its source.
3. Double-click the editor ruler beside an executable line to add a breakpoint.
4. Open **Database** > **Database Debug...**, or the debug (bug) toolbar drop-down > **Database Debug Configurations...**, then create a database debug configuration. **Debug As** on a specific routine is another entry point.
5. Select the data source and routine, then provide values for all `IN` and `INOUT` parameters.
6. Choose **Debug**.

The generic **Run** > **Run Configurations...** menu remains available for other launch types; the database debug type is offered only in **Debug Configurations**. Execute ordinary SQL in the SQL editor. If an older build reports `No tab group defined` when creating an entry in **Run Configurations**, close that dialog, use the database debug entry above, and update to this build. Do not delete the workspace.

![Debug source and breakpoint](./imgs/debug-source.png)

### 6.2 Execution control and variables

| Action | Shortcut | Description |
| --- | --- | --- |
| Step Into | F7 | Enter the procedure or function called by the current line |
| Step Over | F8 | Execute the current line without entering the callee |
| Step Return | Shift+F7 | Continue until the current call frame returns |
| Resume | F9 | Continue to the next breakpoint or completion |
| Terminate | F10 | Terminate the current debug session |

The **Variables** view displays local variables and permits supported values to be changed. The watch view accepts variable names. Server-rejected types, constants, and invalid values are displayed as errors and are never reported as successful updates.

Inspect cursor state:

1. Pause at a line after `OPEN`, `FETCH`, or `CLOSE` and open **Variables**.
2. Find the `refcursor` or `sys_refcursor` variable. When the server supplies recognized state data, its value shows a summary such as `(ROWCOUNT=1, ISOPEN=true, FOUND=true, NOTFOUND=false)`.
3. Expand the cursor to inspect the read-only `%ISOPEN`, `%FOUND`, `%NOTFOUND`, and `%ROWCOUNT` children. `NAME` is also shown when the server provides a portal name; Package cursors also expose `PACKAGE` to distinguish equal names from different packages. Missing attributes are never replaced with `false` or `0`; an explicit null is shown as `NULL`.
4. In **Expressions**, add the cursor variable name, such as `cur`, to inspect its complete state, or `cur%ROWCOUNT` / `cur%ISOPEN` to watch one attribute. Cursor names are case-sensitive; attribute names are case-insensitive. Only variable names and these attributes are supported; arbitrary expressions are not executed. If several packages expose the same cursor name in the selected frame, an unqualified attribute watch reports an ambiguous name. Expand the cursor with the matching `PACKAGE` in Variables instead.
5. Step and inspect the value at the next suspension. Selecting a different call frame displays that frame's state. Stepping no longer forces the visible **Expressions** tab to switch to **Breakpoints**.

The cursor and its state children are read-only. Unrecognized, conflicting, or ambiguous data remains visible as the original value or separate variable rows. The client only interprets data already returned by `info_locals()`; it does not issue an additional `FETCH`, rerun the original query, or set new private session parameters. **This is cursor-state inspection, not a cursor result grid. Result rows, original SQL, and column structure are not available during a pause and require a future server interface.**

![Steps and variables](./imgs/debug-step-variables.png)

### 6.3 Call stack and transaction result

The **Call Stack** view displays nested routine calls. Selecting another frame refreshes source navigation and variables; double-clicking a frame opens the corresponding routine.

![Call stack](./imgs/call-stack.png)

At the end of a session, choose whether to commit or roll back data changes produced during debugging. Rollback is the safer default in shared or production-like environments.

![Debug transaction choice](./imgs/debug-transaction-choice.png)

### 6.4 Selecting Package members

Package members are separate from standalone procedures/functions under a schema. In a new DBeaver debug configuration, select the connection, then expand Schema → target schema → Packages → target package → Procedures → target member in the routine chooser. Package functions are under the same package's Functions folder. For a member with no input parameters, an empty parameter table is expected.

Package member debugging requires a transaction-scoped `SET LOCAL search_path`. Review the setting and its scope on the configuration page, then optionally acknowledge it for this launch. Without that checkbox, choosing **Debug** opens a confirmation showing the connection, database, Package member and setting. Choosing **No** cancels the launch. Once an acknowledgement has been used, repeating the launch from the toolbar or a saved configuration requires a new acknowledgement. Restarting the client does not retain the previous acknowledgement.

**Apply** being disabled is normal when a saved configuration has no changes. **Debug** availability depends on a valid connection, routine and input parameters. Leaving the setting acknowledgement unchecked does not disable **Debug** for an otherwise valid configuration; confirmation is still required at launch.

### 6.5 Breakpoints and source tabs

The **Breakpoints** view retains configured breakpoints for the entire workspace after a session ends or the client restarts. It is not a log of breakpoint hits in the current execution. One connection can contain different databases, routines and lines, so identical connection labels do not by themselves indicate duplicates. Multiple records with the same connection, database, routine OID and line are duplicates.

Breakpoint labels include the connection identity, including when a custom label is used. Toggling a breakpoint at the same source line removes all matching duplicate records while preserving other connections. The client does not clear historical breakpoints automatically. Select unused breakpoints in the **Breakpoints** view to remove them, or uncheck them to disable them.

In **Breakpoints**, a single click selects a breakpoint; double-click to open its source and navigate to the breakpoint line. Merely switching to the Breakpoints or another view tab does not open source automatically. On initial or slow loading, execution-line and instruction-pointer positioning waits until the source document has loaded. After a source tab is closed or another view is selected, outdated asynchronous source results are ignored so the tab is not reopened and focus is not taken back.

## 7. Package compilation and error navigation

1. Expand **Packages** under a schema in a Package-capable database.
2. Right-click a Package.
3. Select full Package, specification-only, or body-only compilation.
4. Review the compilation result and error list.
5. Double-click an error with a line number to navigate to the matching source line.

![Package compilation](./imgs/package-compile-menu.png)

![Package errors](./imgs/package-errors.png)

![Package error navigation](./imgs/package-error-location.png)

Multiple Packages can be selected in Database Navigator for batch deletion. The client displays the object list and asks for confirmation before execution.

![Package batch deletion](./imgs/package-delete-confirm.png)

If a distributed server does not support forced invalid Package bodies or compilation diagnostic views, the client displays the direct server error and does not report compile-error navigation as successful.

## 8. Validation results

Validation of the 2026-11-03 R6 build:

- R6 cursor state: supports the inline state text returned by 507 `info_locals()` and the older name-based hidden-attribute format. Attributes are matched by complete cursor name, Package, and frame; missing, invalid, duplicate, or conflicting data is preserved rather than guessed. Cursor summaries and children are read-only; watches support the cursor and its `%ISOPEN`, `%FOUND`, `%NOTFOUND`, and `%ROWCOUNT` attributes.
- R6 watch refresh: retains stable variable and attribute snapshot identities. Suspension creates missing debug views without activating Variables or Breakpoints, preserving the visible Expressions tab.
- R6 main regression: 3,130 cases, with 2,946 passed, 184 conditionally skipped, zero failures or errors; this build adds 87 regression cases.
- R6 live protocol checks: centralized 507 ORA, covering OPEN, successful and unsuccessful FETCH, CLOSE, multiple cursors, and frame switching; 86 assertions per round, repeated twice with both rounds passing. The older name-based hidden format is unit-tested against supplied protocol fixtures; this release does not claim a new 505-server validation of that format.
- R6 product build and GUI acceptance: All 204 Maven modules built successfully. The final R6 GUI ran in a translated Kylin V10 x86_64 container with a fresh workspace connected to centralized 507 ORA. The real Variables and Expressions views refreshed the cursor and cur%ROWCOUNT watch after OPEN, the first and second FETCH, exhaustion with NOTFOUND, and CLOSE. Both views expanded all four state attributes and NAME with read-only protection. The selected frame, source caret, and execution annotation aligned at line 10. F9 completed normally; rollback left no live debug target or process, and the client exited normally. The six production bundles match the final GUI copy byte for byte; the extracted archive passed all 1,202 manifest entries. Same-frame cursor isolation and ambiguity across Packages are unit-tested; this combination is not claimed as GUI-validated.

The R5, R4, R3, and R2 entries below are historical records; their complete suites were not rerun with R6:

- R5 fixes debug completion state synchronization. Continue and stepping synchronize target and thread running states and clear stale stack frames; the next suspension reads a fresh stack. Resume is disabled while commit/rollback is pending, and outdated queued resume actions are ignored, preventing completed sessions from being treated as resumable paused sessions.
- R5 fixes completion detection during Package stepping. An independent JDBC protocol probe against a live 507 server found that reaching a child routine END can return `[EXECUTION FINISHED]` while child and caller frames remain. The client now matches the marker exactly and reads the backtrace on the same controller connection; a remaining stack is treated as a pause. It does not infer completion from routine OIDs, which may repeat in recursion. Routine completion requires the target CALL to return successfully; only the expected `D0005` backtrace state is treated as a completion signal, and other errors remain visible. This server behavior was confirmed by an independent protocol probe and the revised-client GUI checks below.
- R5 matches error-response markers exactly, so similar text inside source strings or comments is not mistaken for a debug failure. Genuine server error markers still terminate the debug session and report the error.
- R5 main regression: 3,043 total, 2,859 passed, 184 conditionally skipped, zero failures or errors; this build adds 45 regression cases (19 model-state and race cases, and 26 completion/error-marker cases). The R4, R3 and R2 GUI checks below are historical results and were not rerun with R5.
- R5 live GUI checks: a translated Kylin V10 x86_64 container connected to centralized GaussDB 507 ORA. R4 reproduced a completed state with two stack frames still present, followed by `not suspended` on Continue. In R5, F7 entered run_demo → build_result → calc_amount, crossed the server-reported build_result line 0, returned to run_demo line 8, and stepped to normal completion. A second run remained resumable and incomplete at build_result line 0; clicking Continue completed normally.
- R5 transaction checks: Resume and stepping actions were disabled while the final commit/rollback dialog was displayed. After the first run committed, an independent connection read one row. The second run rolled back, and the independent row count remained one.
- R5 product build: 204/204 Maven modules succeeded. The six production bundles involved in the repair are byte-identical to those used for GUI acceptance.

- R4 product build: 204/204 Maven modules succeeded. The extracted release archive passed manifest verification for 1,202 entries; the six production bundles involved in the repair match the GUI acceptance copy.
- Historical R4 main regression: 2,998 total, 2,814 passed, 184 conditionally skipped, zero failures or errors; R4 added 29 regression cases and retained the 69 cases added in R3.
- R4 live GUI checks preserve a real R3 workspace breakpoint across the version restart. Single-click selects without opening an editor. Cold double-click, double-click while the object is on Properties, and the Go to File context action all navigate to source line 6. An injected eight-second source-query delay still ends at line 6. Repeated single-clicks after closing all editors do not reopen source.
- R4 launch checks: Run Configurations lists only other runnable types. The saved database configuration in Debug Configurations remains valid with Debug enabled. An actual run_demo Package launch pauses with both caret and execution annotation at line 6, then continues to completion with rollback selected.
- R3 live GUI checks: explicit per-launch Package acknowledgement; declining leaves no live debug targets or processes. Initial suspend, double-click reopening and three-level F7 navigation place both caret and execution annotation at lines 6, 4 and 6. Closing source or using a native mouse click to return to Breakpoints remains stable for 10 seconds without reopening or focus theft.
- Previously completed in R2: Kylin V10 x86_64 GUI connected to a local centralized GaussDB 507 server: 100 bulk schemas, approximately 15,000 procedures, 3,000 functions, 208 packages and 3,900 synthetic composite types in the database.
- Previously completed in R2: each of two JDBC drivers completed three refresh rounds, with 500 tasks and 12 worker threads per round. The driver concurrency exception reproduced with the previous build did not recur.
- Previously completed in R2: M-mode main and metadata connection initialization, table data reading and debug parameter panel creation passed.
- R2 adds 23 regression cases. GUI checks cover restored duplicate breakpoints across restart, removing matches while preserving another connection, selecting run_demo in a new configuration, F7 into build_result and calc_amount with three frames, frame-specific variables and correct source, and F8 producing amount 30. Commit adds a row; a subsequent rollback leaves the row count unchanged.
- R4 and R3 GUI validation used a Rosetta-translated Kylin V10 x86_64 container on Apple Silicon and a centralized 507 ORA server. R2 previously checked a 505 JDBC driver against that server. These checks do not constitute 505 server or native x86 virtual-desktop acceptance.

The 2026-10-14 baseline previously passed centralized and distributed 505 live-database and independent acceptance checks. That full historical suite was not rerun for this repair build. Persistent loading in a target environment still needs an upgrade retest to establish whether its cause matches the repaired driver concurrency exception.

## 9. Current boundaries

- This ecosystem release contains only the Kylin V10 x86_64 package; ARM64 and Windows packages are not included.
- Locally rebuilt Linux native libraries in the package are not digitally signed. Verify integrity with the published SHA-256 digest and product manifest.
- GaussDB JDBC, `gs_dump`, `gs_restore`, and other native database tools are not distributed with the client.
- PL/SQL debugging depends on server debug APIs, compatibility mode, routine language, and user permissions.
- Package error navigation depends on Package and compilation-diagnostic capabilities in the target server version.
- Paused local cursors expose server-supplied state only. Result rows, original SQL, and column-structure previews require a future server interface. The older name-based hidden format is covered by protocol-fixture unit tests; the current live-server coverage uses the 507 inline format.
- Before first use in a target environment, verify the digest and run organization-specific connection, debugging, transaction, and Package acceptance tests.

## 10. Licensing

DBeaver Community source and these enhancements are provided under the applicable Apache License 2.0 terms. Bundled third-party components remain under their respective licenses; third-party source and license information is included in the package.
