‌[Apache Flink ‌](https://flink.apache.org/) 是一个开源的分布式流处理框架，专为大规模数据处理设计，支持流处理和批处理一体化。它能够在无界和有界数据流上进行有状态计算，具有高吞吐量、低延迟的特性，广泛应用于实时数据处理场景。
本文档主要介绍 [flink-connector-jdbc-gaussdb](https://github.com/HuaweiCloudDeveloper/gaussdb-flink-connector-jdbc) 的使用。

本文档适用于 Flink 1.20.x，当前推荐使用 GaussDB Flink Connector JDBC `3.3.2-1.20`。

相关依赖jar包下载地址:

* [**GaussDB驱动-JDK7**](https://repo1.maven.org/maven2/com/huaweicloud/gaussdb/gaussdbjdbc/506.0.0.b058-jdk7/gaussdbjdbc-506.0.0.b058-jdk7.jar)
* [**GaussDB驱动-JDK17**](https://repo1.maven.org/maven2/com/huaweicloud/gaussdb/gaussdbjdbc/506.0.0.b058/gaussdbjdbc-506.0.0.b058.jar)
* [**flink-connector-jdbc-gaussdb 3.3.2-1.20（标准 Apache Flink）**](https://github.com/huaweicloud-samples/database-gaussdb-flink-connector-jdbc/releases/tag/v3.3.2-1.20-normal)
* [**flink-connector-jdbc-gaussdb 3.3.2-1.20（华为 MRS）**](https://github.com/huaweicloud-samples/database-gaussdb-flink-connector-jdbc/releases/tag/v3.3.2-1.20-mrs)
* [**flink-connector-jdbc-core 3.3.0-1.20**](https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc-core/3.3.0-1.20/)
* [**Flink**](https://flink.apache.org/downloads/)

## 使用说明

1. gaussdb 数据库环境准备  

   gaussdb 数据库实例购买 以及库表创建。(以下为测试代码示例)  <br />
   在gaussdb 数据库创建db test_db,创建schema player, 创建表 players <br />
``` gaussdb sql 
create database test_db;
use test_db;
create schema player;

CREATE TABLE player.players (
player_id INT NOT NULL,
team_id INT,
player_name VARCHAR(255),
height VARCHAR(255),
update_time timestamp,
PRIMARY KEY (player_id)
);
```

2. flink sql 使用场景
*  做源表   <br />
   场景介绍: Flink sql 读取gaussdb players数据后将数据写入printsink表  <br />

```flink sql
CREATE TABLE source (
player_id INT,
team_id INT,
player_name VARCHAR,
height VARCHAR,
update_time timestamp,
PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:gaussdb://1.1.1.1:8000/test_db?currentSchema=player',
'username' = 'user',
'password' = '123456',
'table-name' = 'players');

CREATE TABLE printsink (
player_id INT,
team_id INT,
player_name VARCHAR,
height VARCHAR ,
update_time timestamp
) WITH (
'connector' = 'print'
);

insert into printsink select * from source;
```
**执行成功：**  <br />
![img.png](docs/image/scenario01.png)


*  做结果表  <br />
   场景介绍: Flink sql 读取gaussdb players_source表的数据后将数据写入gaussdb players表  <br />

```flink sql
CREATE TABLE source (
player_id INT,
team_id INT,
player_name VARCHAR,
height VARCHAR,
update_time timestamp,
PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:gaussdb://1.1.1.1:8000/test_db?currentSchema=player',
'username' = 'user',
'password' = '123456',
'table-name' = 'players_source');

CREATE TABLE sink (
player_id INT,
team_id INT,
player_name VARCHAR,
height VARCHAR,
update_time timestamp,
PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:gaussdb://1.1.1.1:8000/test_db?currentSchema=player',
'username' = 'user',
'password' = '123456',
'table-name' = 'players');

insert into sink  select * from source;
```
**执行成功：** <br />
![img.png](docs/image/scenario02.png)


*  做维表  <br />
   场景介绍:  Flink sql 读取gaussdb players_info表数据并join gaussdb维表 players后 将数据写入players_detail 结果表 <br />

```flink sql
CREATE TABLE players (
player_id INT,
team_id INT,
player_name VARCHAR,
height VARCHAR,
update_time timestamp,
PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:gaussdb://1.1.1.1:8000/test_db?currentSchema=player',
'username' = 'user',
'password' = '123456',
'table-name' = 'players');

CREATE TABLE players_info (
player_id INT,
player_name VARCHAR,
phone VARCHAR ,
address VARCHAR ,
email VARCHAR ,
update_time timestamp,
PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
'connector' = 'jdbc',
'url' = 'jdbc:gaussdb://1.1.1.1:8000/test_db?currentSchema=player',
'username' = 'user',
'password' = '123456',
'table-name' = 'players_info');

CREATE TABLE players_detail (
player_id INT,
player_name VARCHAR,
phone VARCHAR ,
address VARCHAR ,
email VARCHAR ,
update_time timestamp,
PRIMARY KEY (player_id) NOT ENFORCED
) WITH (
'connector' = 'print'
);

insert into players_detail   
select ps.player_id, ps.player_name, pi.phone ,pi.address ,pi.email ,pi.update_time from players_info  as pi
inner join  players  as ps  on  ps.player_id = pi.player_id ;
```
**执行成功：** <br />
![img.png](docs/image/scenario03.png)


**注意事项:**
1. GaussDB驱动的选择: 依照Flink集群环境的JDK版本选择对应的驱动版本。
2. 源码仓库地址: [**flink-connector-jdbc-gaussdb**](https://github.com/HuaweiCloudDeveloper/gaussdb-flink-connector-jdbc) , [**flink-connector-jdbc-core**](https://github.com/apache/flink-connector-jdbc)
3. 本文档的内容介绍是对 Flink [Table API Connectors](https://nightlies.apache.org/flink/flink-docs-release-1.20/zh/docs/connectors/table/jdbc/) 方式的实现, Flink [DataStream Connectors](https://nightlies.apache.org/flink/flink-docs-release-1.20/zh/docs/connectors/datastream/jdbc/) 方式请参考官网链接。
