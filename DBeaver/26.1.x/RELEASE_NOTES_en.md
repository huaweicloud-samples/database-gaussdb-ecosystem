# DBeaver 26.1.5 GaussDB Enhanced Edition Release Notes

Release tag: `dbeaver-gaussdb-26.1.5-kylin-x86_64-20261014`

## Assets

This release contains only the Kylin V10 x86_64 edition:

| File | Purpose | SHA-256 |
| --- | --- | --- |
| `DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.tar.gz` | Client archive | `9ce40956dde52360ca3928f600b2d3fd5add036c174c6c9261105a932bfe1484` |
| `DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.PRODUCT-MANIFEST.json` | Package file manifest | `2d4fc028cf9e660509304bebaedbf9021e95ab00d5f185c2d6c8f75db1916a13` |
| `SHA256SUMS` | Checksum entry point for the two payload files above | Generated and read back during publication |

## Highlights

- GaussDB compatibility-mode detection and capability gating.
- Stored procedure and function breakpoints, stepping, resume, and termination.
- Breakpoint management, variable inspection and modification, watches, and call stacks.
- Commit or rollback selection for debug transactions.
- Package specification, body, and full compilation, error navigation, and batch deletion.
- Simplified Chinese resources and complete operation screenshots.

## Validation summary

- Product build 204/204 and packaging tests 43/43 passed.
- Main project regression: 2,867 total, 2,683 passed, 184 conditionally skipped, 0 failed, and 0 errors.
- Independent acceptance gate: 337/337 passed.
- GaussDB 505 distributed live-database acceptance passed.
- GaussDB 505 centralized live-database acceptance passed 12/12.
- The final Kylin V10 x86_64 archive passed a clean-workspace, Simplified Chinese UI, and GaussDB debug plug-in cold-start check.

## Boundaries

- ARM64 and Windows packages are not included in this release.
- Locally rebuilt Linux native libraries in the package are not digitally signed; use SHA-256 and the product manifest for integrity verification.
- The x86_64 GUI check used a Kylin V10 x86_64 user space with host instruction translation; it does not replace final target-device or virtual-desktop admission testing.
- The GaussDB JDBC driver and native database tools are not bundled.
- M compatibility mode is supported for basic database use; PL/SQL debugging is not claimed for M mode.
- Complete Package compilation and error navigation depend on the target deployment and server capabilities.

See the [usage guide](./README_en.md) for installation and operating instructions.
