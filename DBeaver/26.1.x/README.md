# DBeaver 26.1.5 GaussDB 增强版使用指南

构建版本：`26.1.5.202611022032`；更新日期：2026-11-02。Release 标签、安装包、文件清单和校验文件统一对应本次构建。

## 1. 概述

本版本基于 DBeaver 26.1.5 官方源码及其 GaussDB 核心插件进行增强，面向 GaussDB 日常开发、存储过程调试和 Package 管理场景。

本次增强复用了 DBeaver 的数据库对象模型、SQL 编辑器、Eclipse RCP 和通用调试框架，并补充了以下能力：

- GaussDB 兼容模式识别及按能力显示功能入口。
- 存储过程和函数的断点调试。
- 单步进入（F7）、单步跳过（F8）、单步退出（Shift+F7）、继续（F9）和终止（F10）。
- 断点新增、启用、禁用、删除和统一管理。
- 局部变量查看与修改、监视变量、调用堆栈及源码跳转。
- 调试结束后的提交或回滚选择。
- Package 规格、包体及整体编译，编译错误定位和批量删除。

源码基线：

- [DBeaver GaussDB 增强版源码标签](https://github.com/jarrenL/dbeaver/tree/gaussdb-2615-x86_64-beta-20261102-r2)
- 源码修订：`06183e4d70614e87a5440b6d1663e4aa71b7d762`
- [独立测试工程](https://github.com/jarrenL/gaussdb-dbeaver-tests)
- 测试修订：`96690286a163c0f3898fab3d3877098520384f3d`

## 2. 适用范围

| 项目 | 当前发布范围 |
| --- | --- |
| 客户端版本 | DBeaver 26.1.5 GaussDB 增强版 |
| 客户端系统 | 麒麟 V10 x86_64 |
| 已验数据库 | GaussDB 505.2.1.SPC0800，集中式与分布式 |
| 数据库兼容模式 | 支持识别 ORA/A、MYSQL/B、TD/C、PG、M；具体功能按服务端能力开放 |
| PL/SQL 调试 | 服务端具备 `DBE_PLDEBUGGER` 接口且用户有相应权限时开放 |
| Package | 以支持 Package 的集中式 ORA 环境为完整能力范围；其他部署形态按服务端能力降级 |

M 兼容模式支持连接、对象浏览和基础 SQL 操作，但不声明支持 PL/SQL 调试。客户端会在入口和启动阶段检查数据库兼容模式、过程语言、调试接口签名及用户权限，不满足条件时给出明确提示。

## 3. 下载与完整性校验

本次生态仓 Release 仅提供近期主测的麒麟 V10 x86_64 客户端：

- [Release 页面](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/tag/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r2)
- [dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.tar.gz](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r2/dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.tar.gz)
- [产品文件清单](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r2/dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.PRODUCT-MANIFEST.json)
- [SHA256SUMS](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261102-r2/SHA256SUMS)

SHA-256：

```text
b41981f14ef8d444c89a29a72ff6ee321d0675eb3937c877613ea325daa65e73  dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.tar.gz
```

下载后执行：

```bash
sha256sum dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.tar.gz
uname -m
```

`uname -m` 应返回 `x86_64`，并且摘要必须与上方一致。ARM64/aarch64 机器不能运行该包。

## 4. 安装与启动

本发布包为免安装归档，内置 Java 21 运行环境。建议解压到新目录，不要覆盖正在使用的旧目录。

```bash
tar -xzf dbeaver-ce-26.1.5-gaussdb-linux-x86_64-202611022032.tar.gz
cd dbeaver
./dbeaver
```

如果启动文件没有执行权限：

```bash
chmod +x dbeaver
./dbeaver
```

需要强制使用简体中文启动时：

```bash
./dbeaver -nl zh
```

![简体中文配置](./imgs/language-config.png)

关闭窗口后，后台进程可能还需十几秒保存工作区并退出。请等待进程结束后再启动下一实例，否则可能出现 `Can't lock workspace`。

## 5. 配置 GaussDB JDBC 驱动

发布包不内置 GaussDB JDBC 驱动。请使用与目标数据库版本匹配、经过组织审批的驱动：

1. 启动 DBeaver，选择“数据库”→“驱动管理器”。
2. 选择 `GaussDB`，点击“编辑”。
3. 在“库”页添加 GaussDB JDBC JAR。
4. 确认驱动类为驱动包提供的 GaussDB JDBC 类。
5. 保存后新建连接，填写主机、端口、数据库、用户名和密码。
6. 点击“测试连接”，确认数据库版本、兼容模式和当前用户均符合预期。

客户端不会在后台静默修改会话级私有参数。若特定服务端能力要求额外参数，能力检查或错误信息会明确提示，由用户或数据库管理员确认后显式设置。

GaussDB 内置驱动默认取消“Thread safe driver”，使同一连接上的语句和结果读取互斥，避免多 Schema 并发刷新触发驱动内部异常；不同连接仍可并行。旧工作区或自定义驱动若显式启用了此选项，请在“数据库 → 驱动管理器 → 编辑驱动”中取消后重新连接。这是客户端选项，不修改数据库会话参数。

## 6. 调试存储过程或函数

### 6.1 启动调试

1. 在“数据库导航器”中展开目标数据库、模式及“存储过程”或“函数”。
2. 打开需要调试的对象并保存源码。
3. 在可执行代码行左侧标尺双击设置断点。
4. 右键对象，选择“调试方式”→“GaussDB routine”；也可以打开“调试配置”新建 GaussDB 配置。
5. 选择数据源和例程，为所有 `IN`/`INOUT` 参数填写值。
6. 点击“调试”。

![调试源码和断点](./imgs/debug-source.png)

### 6.2 调试控制与变量

| 操作 | 快捷键 | 说明 |
| --- | --- | --- |
| 单步进入 | F7 | 进入当前行调用的过程或函数 |
| 单步跳过 | F8 | 执行当前行但不进入被调用对象 |
| 单步退出 | Shift+F7 | 运行到当前调用层返回 |
| 继续 | F9 | 运行到下一个断点或结束 |
| 终止 | F10 | 终止当前调试会话 |

在“变量”视图中可以查看局部变量；选择可修改变量后编辑其值。监视视图支持按变量名添加监视项。服务端拒绝的类型、常量或非法值会显示明确错误，不会伪装为修改成功。

![单步和变量](./imgs/debug-step-variables.png)

### 6.3 调用堆栈与事务处理

“调用堆栈”视图显示当前多层调用关系。选择不同栈帧时，源码位置和变量视图会随之刷新；双击栈帧可导航到对应过程或函数。

![调用堆栈](./imgs/call-stack.png)

调试结束时，可以选择提交或回滚调试产生的数据修改。生产或共享环境中，建议默认选择回滚，确认结果后再执行正式事务。

![调试事务选择](./imgs/debug-transaction-choice.png)

### 6.4 选择包内过程或函数

Package 内的成员不属于 Schema 下的独立“存储过程／函数”列表。新建调试配置时，选择 DBeaver 类型及目标连接，再在“调试对象”选择器展开：模式 → pkg_debug_demo → 包 → demo_pkg → 存储过程 → run_demo。选择包内函数时，展开同一包的“函数”分支。run_demo 无输入参数，参数表为空正常；阅读页面显示的事务级 search_path 设置并明确确认后，点击应用、调试。

[可直接创建的 Package SQL 样例及逐步测试说明](./examples/package-debug/使用说明.txt)。依次执行 01_prepare.sql、02_package_spec.sql、03_package_body.sql；包规格和包体分别作为完整语句执行。gsql 需要各自在末尾另起一行输入 `/`。样例只用于 ORA/A 测试库。

R2 修复了选择器过滤掉 Package 分支、未预展开成员时源码查找失败的问题。断点视图会保留整个工作区的历史断点，结束会话并不自动删除；R2 显示连接标识，并在同一行切换时清除全部匹配的重复记录，不自动清空其他连接的断点。

## 7. Package 编译和错误定位

1. 在支持 Package 的数据库中展开模式下的“包”。
2. 右键目标 Package。
3. 根据需要选择“编译包”“编译包规格”或“编译包体”。
4. 查看编译结果和错误列表。
5. 双击带行号的错误，跳转到对应源码位置。

![Package 编译入口](./imgs/package-compile-menu.png)

![Package 错误列表](./imgs/package-errors.png)

![Package 错误定位](./imgs/package-error-location.png)

可以在数据库导航器中多选 Package 后执行删除。执行前会显示对象清单及确认对话框，便于复核批量操作范围。

![Package 批量删除确认](./imgs/package-delete-confirm.png)

分布式版本若不支持强制创建无效包体或编译错误系统视图，客户端会显示服务端直接返回的编译错误，不会把该路径报告为“错误定位成功”。

## 8. 验证结果

2026-11-02 修复构建的验证结果：

- 产品构建：204/204 个 Maven 模块成功。
- 主工程回归：2900 项，2716 通过、184 项按条件跳过、0 失败、0 错误。
- 麒麟 V10 x86_64 图形环境连接本地 GaussDB 507 集中式真库；100 个批量 Schema，数据库约 1.5 万个过程、3000 个函数、208 个包和 3900 个合成复合类型。
- 两份 JDBC 驱动各完成三轮并发刷新；每轮 500 个任务、12 个工作线程。旧版复现的驱动并发异常未再出现。
- M 模式主连接和元数据连接初始化、表数据读取、调试参数面板创建通过。
- R2 新增 23 项回归测试；GUI 验证历史重复断点重启恢复、删除匹配项并保留其他连接；新配置选择包内 run_demo，F7 进入 build_result、calc_amount，三层堆栈、各帧变量与正确源码可用，F8 后金额为 30；提交增加一行、再次调试回滚后行数不变。
- 本轮使用 Apple Silicon 上的 Rosetta 转译容器；505 JDBC 驱动在 507 服务端验证，不等同于 505 服务端或原生 x86 桌面云验收。

此前 2026-10-14 基线完成过 505 集中式、分布式真库及独立验收；本次没有重新运行该历史验收的全部场景。目标环境持续加载是否与已修复的驱动并发异常为同一原因，仍需升级后现场复测。

## 9. 当前边界

- 本 Release 只提供麒麟 V10 x86_64 包，不包含 ARM64 和 Windows 包。
- 包内本地重建的 Linux 原生库未进行数字签名，请以本页公布的 SHA-256 和产品文件清单校验完整性。
- GaussDB JDBC 驱动、`gs_dump`、`gs_restore` 等数据库原生工具不随客户端分发。
- PL/SQL 调试依赖服务端调试接口、兼容模式、例程语言和用户权限。
- Package 错误定位依赖目标版本提供相应的 Package 和编译诊断能力。
- 首次用于目标环境时，应按照组织的软件准入流程核对摘要，并完成连接、调试、事务和 Package 场景验收。

## 10. 许可证

DBeaver Community 源码及本增强版本遵循其适用的 Apache License 2.0。第三方组件继续遵循各自许可证；包内提供第三方源码与许可证说明。
