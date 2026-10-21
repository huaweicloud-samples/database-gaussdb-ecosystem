# DBeaver 26.1.5 GaussDB 增强版使用指南

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

- [DBeaver GaussDB 增强版源码标签](https://github.com/jarrenL/dbeaver/tree/gaussdb-2615-20261014)
- 源码修订：`3a20ec0742936c1bcfa861e2f0470b1eb980e8d4`
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

- [Release 页面](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/tag/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261014)
- [DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.tar.gz](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261014/DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.tar.gz)
- [产品文件清单](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261014/DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.PRODUCT-MANIFEST.json)
- [SHA256SUMS](https://github.com/huaweicloud-samples/database-gaussdb-ecosystem/releases/download/dbeaver-gaussdb-26.1.5-kylin-x86_64-20261014/SHA256SUMS)

SHA-256：

```text
9ce40956dde52360ca3928f600b2d3fd5add036c174c6c9261105a932bfe1484  DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.tar.gz
```

下载后执行：

```bash
sha256sum DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.tar.gz
uname -m
```

`uname -m` 应返回 `x86_64`，并且摘要必须与上方一致。ARM64/aarch64 机器不能运行该包。

## 4. 安装与启动

本发布包为免安装归档，内置 Java 21 运行环境。建议解压到新目录，不要覆盖正在使用的旧目录。

```bash
tar -xzf DBeaver-GaussDB-26.1.5-202610140553-KylinV10-x86_64.tar.gz
cd linux-x86_64/dbeaver
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

该发布对应的验证结果如下：

- 产品构建：204/204 个 Maven 模块成功。
- 打包测试：43/43 通过。
- 主工程回归：2867 项，2683 通过、184 项按环境条件跳过、0 失败、0 错误。
- 独立验收门禁：337/337 通过。
- GaussDB 505 分布式真库验收通过。
- GaussDB 505 集中式真库验收 12/12 通过，包括调试协议、会话控制和三层 Package 调用栈。
- 麒麟 V10 x86_64 最终归档完成全新工作区、简体中文界面和 GaussDB 调试插件冷启动验证。

本次 x86_64 图形界面验证在麒麟 V10 x86_64 用户态环境中完成，宿主机使用指令转换运行；该结果不替代目标物理机或桌面云的最终准入验收。

## 9. 当前边界

- 本 Release 只提供麒麟 V10 x86_64 包，不包含 ARM64 和 Windows 包。
- 包内本地重建的 Linux 原生库未进行数字签名，请以本页公布的 SHA-256 和产品文件清单校验完整性。
- GaussDB JDBC 驱动、`gs_dump`、`gs_restore` 等数据库原生工具不随客户端分发。
- PL/SQL 调试依赖服务端调试接口、兼容模式、例程语言和用户权限。
- Package 错误定位依赖目标版本提供相应的 Package 和编译诊断能力。
- 首次用于目标环境时，应按照组织的软件准入流程核对摘要，并完成连接、调试、事务和 Package 场景验收。

## 10. 许可证

DBeaver Community 源码及本增强版本遵循其适用的 Apache License 2.0。第三方组件继续遵循各自许可证；包内提供第三方源码与许可证说明。
