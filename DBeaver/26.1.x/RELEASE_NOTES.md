# DBeaver 26.1.5 GaussDB 增强版发布说明

应用构建：`26.1.5.20261105r3`；交付修订：`20261105-r3`；更新日期：2026-11-05。

发布标签：`dbeaver-gaussdb-26.1.5-kylin-20261105-r3`。本次交付麒麟 V10 x86_64 与 ARM64/aarch64 两种客户端，修复分区属性、二级分区入口和刷新。

## 发布资产

| 文件 | 用途 |
| --- | --- |
| `dbeaver-ce-26.1.5-gaussdb-linux-x86_64-20261105-r3.tar.gz` | Linux x86_64 成品客户端，内置 Java 21 |
| `dbeaver-ce-26.1.5-gaussdb-linux-aarch64-20261105-r3.tar.gz` | Linux ARM64 成品客户端，内置 Java 21 |
| 对应架构的 `*.PRODUCT-MANIFEST.json` | 包内文件、权限与链接清单 |
| `dbeaver-gaussdb-enhanced-source-20261105-r3.tar.gz` | 完整增强源码、匹配的 dbeaver-common、JDK/SWT/Equinox 对应源码及清单 |
| `GaussDB_DBeaver_Debug_and_Package_Manual_20261105.docx` | V1.11 连接、调试及 Package 操作手册（中文） |
| `SHA256SUMS` | 本次发布文件的预期校验值 |

下载入口及架构选择见[使用指南](./README.md#3-下载与完整性校验)。最终摘要以 [Release 的 SHA256SUMS](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-20261105-r3/SHA256SUMS) 为准。增强源码应选择明确命名的 `dbeaver-gaussdb-enhanced-source-20261105-r3.tar.gz`；GitHub 默认 Source code 链接对应生态仓自身文档树。

Word 操作手册为 V1.11，包含当前统一连接入口、驱动配置、M 选项、调试、Package 和分区操作的完整窗口图示。在线分区操作说明及两种架构完整截图见[在线使用指南第 8 节](./README.md#8-查看分区表和子分区)。

## 本次修复

- 新建连接统一为一个 **GaussDB** 入口；旧三个驱动定义从新建选择器隐藏，已保存连接仍按原定义加载，原有 URL、驱动管理器和迁移/导入保持可用。图库、最近列表、分类与树视图均应用同一过滤规则。
- 默认使用常用 gsjdbc4 的 `org.postgresql.Driver` 与 `jdbc:postgresql:`；驱动编辑页可按官方 JAR 实际类名调整，`com.huawei.gaussdb.jdbc.Driver` 应配 `jdbc:gaussdb:`，不按文件名判断。连接 M 库时显式勾选 **M 兼容库：mCompatible=true、yearIsDateType=true**；A/O 库不勾。该选项只设置本连接的 JDBC 参数，不修改数据库模式。

- 恢复表结构页的分区标志和分区依据，显示实际列名并保留需要的标识符引号。
- 区分一级分区自身边界与下一级的分区策略、键，正确展示二级分区属性；INTERVAL 自动分区按范围边界展示。
- 为 GaussDB 注册明确的物理子分区入口，修复继承导航树丢失递归链接后，一级分区无展开箭头、属性页无子分区列表的问题。此修复同时适用于本次两种架构，未改变 PostgreSQL 的导航配置。
- 从 `pg_partition` 重载已刷新的分区对象并更新父缓存，增删子分区后 F5 能刷新导航树及已打开列表。

本轮 Java 功能修订：`83c09896ee825b0b10c2462ef10001733128d087`。完整交付源码和依赖组件的修订见 [SOURCE-REVISIONS.json](./SOURCE-REVISIONS.json)。

## 本轮验证

- 主工程 OSGi JUnit：3197 项，3013 通过、184 按条件跳过、0 失败、0 错误；新增 60 项分区、驱动入口、旧连接及连接参数回归。完整单元回归运行于构建机，未宣称在 ARM 重新执行全部 3197 项。
- 43 项打包脚本检查通过，204 个产品模块构建成功。
- 两种真实图形客户端在麒麟 Linux Advanced Server V10（Lance）容器中连接同一 GaussDB 507 集中式 ORA 库；x86_64 通过宿主机指令转译执行，ARM64 使用原生 ARM64 用户态。两容器共享 LinuxKit 内核。
- 七表矩阵均通过：RANGE、LIST、HASH、INTERVAL、带引号列名、普通表、二级分区表；实际元数据、属性描述符与边界逐行一致。
- 两边均通过一级分区展开、子分区页与边界展示、叶子节点隐藏空入口；保持同一连接及缓存后，新增子分区并 F5，树和列表从 2 项变 3 项，删除后 F5 恢复 2 项。
- 451 个同名共享 JAR 字节一致；两份归档分别重新解压并完成 1202 项应用清单校验。

本版的实际检查范围及 x86_64/ARM64 对照结果见[使用指南第 9 节](./README.md#9-验证结果)。目标环境仍须完成连接、调试、事务和 Package 验收。

## 使用边界

- 本 Release 提供 Linux x86_64 和 ARM64 包，不提供本轮未构建及验收的 Windows、macOS 包。按 `uname -m` 选择客户端。
- 本轮 ARM 是启动、连接及分区功能的图形冒烟对照；容器验证不替代客户物理机、原生麒麟内核或桌面云准入验收。
- GaussDB JDBC 驱动与数据库原生工具不随客户端分发；需添加与服务端匹配的 JDBC JAR。
- M 兼容模式按基础数据库能力使用，不声明支持 PL/SQL 调试。调试、Package 编译和错误定位仍受服务端接口、部署形态及权限约束。
- 游标调试显示服务端提供的状态，尚不提供结果行、原 SQL 或列结构预览。
- 包内重建的 Linux 原生库未签名，请使用本次校验文件和产品清单核对完整性。
