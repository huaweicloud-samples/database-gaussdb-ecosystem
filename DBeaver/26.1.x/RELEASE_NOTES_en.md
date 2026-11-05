# DBeaver 26.1.5 GaussDB Enhanced Edition Release Notes

Application build: `26.1.5.20261105r3`; delivery revision: `20261105-r3`; updated on 2026-11-05.

Release tag: `dbeaver-gaussdb-26.1.5-kylin-20261105-r3`. This release provides Kylin V10 x86_64 and ARM64/aarch64 clients and fixes partition properties, subpartition entry points, and refresh.

## Assets

| File | Purpose |
| --- | --- |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261105-r3.tar.gz` | Linux x86_64 client with Java 21 |
| `dbeaver-ce-26.1.5-gaussdb-linux-aarch64-20261105-r3.tar.gz` | Linux ARM64 client with Java 21 |
| Architecture-specific `*.PRODUCT-MANIFEST.json` | Application file, permission, and link inventory |
| `dbeaver-gaussdb-enhanced-source-20261105-r3.tar.gz` | Complete enhanced source, matching dbeaver-common, and source inventory |
| `GaussDB_DBeaver_Debug_and_Package_Manual_20261105.docx` | V1.10 connection, debugging, and Package manual (Chinese) |
| `SHA256SUMS` | Expected digests for the release assets |

See the [guide](./README_en.md#3-download-and-integrity-verification) for downloads and architecture selection. Use the final [Release SHA256SUMS](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-20261105-r3/SHA256SUMS) for integrity checks. Select the explicitly named `dbeaver-gaussdb-enhanced-source-20261105-r3.tar.gz` for enhanced DBeaver source; GitHub's default Source code links archive the ecosystem documentation tree.

The Word manual is updated to V1.10 with R3 download links and illustrated partition instructions. Online steps and complete-window screenshots for both architectures are in [section 8 of the online guide](./README_en.md#8-inspect-partitions-and-subpartitions).

## Fixes

- Unify new connections under one **GaussDB** entry. Hide the three previous definitions from the picker while preserving saved connections, existing URLs, Driver Manager, and migration/import behavior.
- Default to the commonly used gsjdbc4 class `org.postgresql.Driver` with `jdbc:postgresql:`. The driver editor can match the actual official JAR class; `com.huawei.gaussdb.jdbc.Driver` uses `jdbc:gaussdb:`. Do not infer the class from the filename. Select **M compatibility: mCompatible=true, yearIsDateType=true** only for M databases. This sets JDBC properties for the connection and does not change database mode.
- Restore the partition flag and partition key in the table editor, using actual column names with identifier quoting where required.
- Read first-level partition boundaries separately from the strategy and keys used by their subpartitions. Display automatic INTERVAL partitions using range-boundary notation.
- Register explicit physical-subpartition navigation for GaussDB. This restores expansion arrows and the editor's Subpartitions page after inherited navigator recursion was lost. Both architectures receive this fix; PostgreSQL's navigator configuration is unchanged.
- Reload refreshed partitions from `pg_partition` and update the parent cache so F5 reflects added or removed children in both the tree and open list.

Java functional revision: `83c09896ee825b0b10c2462ef10001733128d087`. Complete delivered-source and dependency revisions are recorded in [SOURCE-REVISIONS.json](./SOURCE-REVISIONS.json).

## Validation in this round

- Main OSGi JUnit suite: 3,197 cases; 3,013 passed, 184 conditionally skipped, zero failures or errors. Sixty partition, driver-visibility, saved-connection and JDBC-option cases were added. The complete suite ran on the build host; the full 3,197-case suite was not rerun on ARM.
- All 43 packaging-script checks passed and all 204 product modules built successfully.
- Real GUIs in Kylin Linux Advanced Server V10 (Lance) containers connected to the same centralized GaussDB 507 ORA database. x86_64 used host instruction translation; ARM64 used native ARM64 user space. Both containers share the LinuxKit kernel.
- The seven-table matrix passed on both: RANGE, LIST, HASH, INTERVAL, quoted column name, ordinary table, and two-level partition table. Actual metadata, property descriptors, and boundaries matched line for line.
- Both clients passed first-level expansion, Subpartitions page and boundaries, and leaf-folder hiding. With the same connection and cached children, adding a subpartition and pressing F5 changed the tree and list from 2 to 3; dropping it and pressing F5 restored 2.
- All 451 identically named shared JARs match byte for byte. Both archives were freshly extracted and passed their 1,202-entry application inventories.

Historical connection, debugging, cursor, composite-argument, and Package results retain their original build dates in [section 9 of the guide](./README_en.md#9-validation-results). They do not establish that all historical scenarios were rerun in this round or on ARM.

## Boundaries

- This release provides Linux x86_64 and ARM64 archives. Windows and macOS packages were not built and accepted in this round. Choose by `uname -m`.
- ARM validation in this round is a startup, connection, and partition GUI smoke comparison. Container results do not replace acceptance on customer hardware, a native Kylin kernel, or a virtual desktop.
- GaussDB JDBC drivers and native database tools are not bundled. Add a JDBC JAR matching the target server.
- M compatibility mode exposes basic database capabilities; this release does not claim M-mode PL/SQL debugging. Debugging, Package compilation, and error navigation remain subject to server interfaces, deployment type, and permissions.
- Cursor debugging displays server-provided state; it does not preview result rows, original SQL, or column structures.
- Locally rebuilt Linux native libraries are unsigned. Check integrity using this release's digests and product manifests.

For the unified entry, omit `mCompatible` and `yearIsDateType` from URL query strings. The connection page rejects these conflicting URL parameters; use the explicit M option or the Driver properties page.
