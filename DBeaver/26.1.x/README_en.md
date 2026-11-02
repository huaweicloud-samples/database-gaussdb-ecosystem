# DBeaver 26.1.5 GaussDB Enhanced Edition Guide

Build: `26.1.5.20261102r3`; updated on 2026-11-02. The release tag, archive, product manifest and checksums all identify this build.

## 1. Overview

This edition is based on the official DBeaver 26.1.5 source tree and its GaussDB core plug-in. It extends DBeaver for GaussDB application development, stored routine debugging, and Package management.

It reuses the official DBeaver object model, SQL editor, Eclipse RCP platform, and generic debug framework, and adds:

- GaussDB compatibility-mode detection and capability-based feature gating.
- Breakpoint debugging for stored procedures and functions.
- Step Into (F7), Step Over (F8), Step Return (Shift+F7), Resume (F9), and Terminate (F10).
- Breakpoint creation, enable/disable, deletion, and centralized management.
- Local variable inspection and modification, watches, call stacks, and source navigation.
- Commit or rollback selection when a debug session finishes.
- Package specification, body, and full compilation, compile-error navigation, and batch deletion.

Source baselines:

- [DBeaver GaussDB enhanced source tag](https://github.com/jarrenL/dbeaver/tree/gaussdb-2615-x86_64-beta-20261102-r3)
- Source revision: `ecf40f372a1ef432d75078b51f6d5cda5c68267e`
- [Independent test project](https://github.com/jarrenL/gaussdb-dbeaver-tests)
- Test revision: `96690286a163c0f3898fab3d3877098520384f3d`

## 2. Scope

| Item | Current release scope |
| --- | --- |
| Client version | DBeaver 26.1.5 GaussDB Enhanced Edition |
| Client platform | Kylin V10 x86_64 |
| Validated database | GaussDB 505.2.1.SPC0800, centralized and distributed deployments |
| Compatibility modes | Detects ORA/A, MYSQL/B, TD/C, PG, and M; features are enabled according to server capabilities |
| PL/SQL debugging | Enabled when the server provides the required `DBE_PLDEBUGGER` signatures and the current user has permission |
| Package management | Full capability is intended for Package-capable centralized ORA deployments; other deployments use capability-based fallback behavior |

M compatibility mode supports connections, object browsing, and basic SQL operations. This release does not claim PL/SQL debugging support for M mode. The client checks compatibility mode, routine language, debug API signatures, and permissions before starting a session and displays an explicit reason when a requirement is not met.

## 3. Download and integrity verification

The ecosystem release currently contains only the recently validated Kylin V10 x86_64 client:

- [Release page](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/tag/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r3)
- [dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r3.tar.gz](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r3/dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r3.tar.gz)
- [Product manifest](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r3/dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r3.PRODUCT-MANIFEST.json)
- [SHA256SUMS](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r3/SHA256SUMS)

SHA-256:

```text
56a1fc08de50d2e8151c3238c233b664259eec3b4095742220bd12432f7ae71c  dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r3.tar.gz
```

Verify the download and architecture:

```bash
sha256sum dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r3.tar.gz
uname -m
```

`uname -m` must report `x86_64`, and the digest must match the value above. This package cannot run on ARM64/aarch64 systems.

## 4. Installation and startup

The release is a portable archive with a bundled Java 21 runtime. Extract it into a new directory instead of overwriting an active installation.

```bash
tar -xzf dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261102-r3.tar.gz
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
4. Right-click the routine and choose **Debug As** > **GaussDB routine**, or create a GaussDB entry in **Debug Configurations**.
5. Select the data source and routine, then provide values for all `IN` and `INOUT` parameters.
6. Choose **Debug**.

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

Selecting a breakpoint navigates to its source. After a source tab is closed or another view is selected, outdated asynchronous source results are ignored so the tab is not reopened and focus is not taken back.

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

Validation of the 2026-11-02 repair build:

- Product build: 204/204 Maven modules succeeded.
- Main regression: 2,969 total, 2,785 passed, 184 conditionally skipped, zero failures or errors; R3 adds 69 regression cases.
- R3 live GUI checks: explicit per-launch Package acknowledgement; declining leaves no live debug targets or processes. Initial suspend, double-click reopening and three-level F7 navigation place both caret and execution annotation at lines 6, 4 and 6. Closing source or using a native mouse click to return to Breakpoints remains stable for 10 seconds without reopening or focus theft.
- Previously completed in R2: Kylin V10 x86_64 GUI connected to a local centralized GaussDB 507 server: 100 bulk schemas, approximately 15,000 procedures, 3,000 functions, 208 packages and 3,900 synthetic composite types in the database.
- Previously completed in R2: each of two JDBC drivers completed three refresh rounds, with 500 tasks and 12 worker threads per round. The driver concurrency exception reproduced with the previous build did not recur.
- Previously completed in R2: M-mode main and metadata connection initialization, table data reading and debug parameter panel creation passed.
- R2 adds 23 regression cases. GUI checks cover restored duplicate breakpoints across restart, removing matches while preserving another connection, selecting run_demo in a new configuration, F7 into build_result and calc_amount with three frames, frame-specific variables and correct source, and F8 producing amount 30. Commit adds a row; a subsequent rollback leaves the row count unchanged.
- R3 GUI validation used a Rosetta-translated container on Apple Silicon and a centralized 507 server. R2 previously checked a 505 JDBC driver against that server. These checks do not constitute 505 server or native x86 virtual-desktop acceptance.

The 2026-10-14 baseline previously passed centralized and distributed 505 live-database and independent acceptance checks. That full historical suite was not rerun for this repair build. Persistent loading in a target environment still needs an upgrade retest to establish whether its cause matches the repaired driver concurrency exception.

## 9. Current boundaries

- This ecosystem release contains only the Kylin V10 x86_64 package; ARM64 and Windows packages are not included.
- Locally rebuilt Linux native libraries in the package are not digitally signed. Verify integrity with the published SHA-256 digest and product manifest.
- GaussDB JDBC, `gs_dump`, `gs_restore`, and other native database tools are not distributed with the client.
- PL/SQL debugging depends on server debug APIs, compatibility mode, routine language, and user permissions.
- Package error navigation depends on Package and compilation-diagnostic capabilities in the target server version.
- Before first use in a target environment, verify the digest and run organization-specific connection, debugging, transaction, and Package acceptance tests.

## 10. Licensing

DBeaver Community source and these enhancements are provided under the applicable Apache License 2.0 terms. Bundled third-party components remain under their respective licenses; third-party source and license information is included in the package.
