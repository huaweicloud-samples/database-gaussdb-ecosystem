# DBeaver 26.1.5 GaussDB Enhanced Edition Release Notes

Build: `26.1.5.202611022032`; updated on 2026-11-02. The release tag, archive, product manifest and checksums all identify this build.

Release tag: `dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r2`

## Assets

This release contains only the Kylin V10 x86_64 edition:

| File | Purpose | SHA-256 |
| --- | --- | --- |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.tar.gz` | Client archive | `b41981f14ef8d444c89a29a72ff6ee321d0675eb3937c877613ea325daa65e73` |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.PRODUCT-MANIFEST.json` | Package file manifest | `8cc17b31a9ea830376c09080228ac9ce86c2d6d531dea4dfc02f8f9de6af126d` |
| `SHA256SUMS` | Checksum entry point for the two payload files above | Generated and read back during publication |

## Highlights

- GaussDB compatibility-mode detection and capability gating.
- Stored procedure and function breakpoints, stepping, resume, and termination.
- Breakpoint management, variable inspection and modification, watches, and call stacks.
- Commit or rollback selection for debug transactions.
- Package specification, body, and full compilation, error navigation, and batch deletion.
- Simplified Chinese resources and complete operation screenshots.

## Repairs and validation in this build

- R2: Package member selection, cold source navigation, stable breakpoint identity and removal of all matching duplicates; connection identities in breakpoint labels.
- R2 adds 23 regression cases and live GUI checks for three Package frames, variables, source, stepping and commit/rollback data results.
- Fix JDBC driver concurrency failures during parallel multi-schema metadata loading.
- Fix M-mode SESSION_USER connection initialization errors.
- Include the debug parameter panel layoutData null-pointer repair and guidance for stale routine OIDs.
- All 204 product modules built; main regression: 2,716 passed, 184 skipped, zero failures or errors.
- Two drivers each passed three multi-schema refresh rounds of 500 tasks; M-mode data reading and parameter panel creation passed.
- This run used a translated Kylin V10 x86_64 container and centralized 507 server, including the 505 JDBC driver. The full historical 505 server suite was not rerun. See the usage guide for validation boundaries.

## Boundaries

- ARM64 and Windows packages are not included in this release.
- Locally rebuilt Linux native libraries in the package are not digitally signed; use SHA-256 and the product manifest for integrity verification.
- The x86_64 GUI check used a Kylin V10 x86_64 user space with host instruction translation; it does not replace final target-device or virtual-desktop admission testing.
- The GaussDB JDBC driver and native database tools are not bundled.
- M compatibility mode is supported for basic database use; PL/SQL debugging is not claimed for M mode.
- Complete Package compilation and error navigation depend on the target deployment and server capabilities.

See the [usage guide](./README_en.md) for installation and operating instructions.
