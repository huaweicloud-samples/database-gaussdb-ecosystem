[Apache Flink](https://flink.apache.org/)	is an open-source distributed stream processing framework designed for large-scale data processing and supports the integration of stream processing and batch processing. It can perform stateful computing on unbounded and bounded data streams, and has the characteristics of high throughput and low latency. It is widely used in real-time data processing scenarios. 

This document mainly describes the use of[Flink-connector-jdbc-gaussdb](https://github.com/HuaweiCloudDeveloper/gaussdb-flink-connector-jdbc)	. 

This document applies to Flink 1.20.x. The recommended GaussDB Flink Connector JDBC version is `3.3.2-1.20`.

Related package downloads:

* [**GaussDB Driver-JDK7**](https://repo1.maven.org/maven2/com/huaweicloud/gaussdb/gaussdbjdbc/506.0.0.b058-jdk7/gaussdbjdbc-506.0.0.b058-jdk7.jar)
* [**GaussDB Driver-JDK17**](https://repo1.maven.org/maven2/com/huaweicloud/gaussdb/gaussdbjdbc/506.0.0.b058/gaussdbjdbc-506.0.0.b058.jar)
* [**flink-connector-jdbc-gaussdb 3.3.2-1.20 (standard Apache Flink)**](https://github.com/huaweicloud-samples/database-gaussdb-flink-connector-jdbc/releases/tag/v3.3.2-1.20-normal)
* [**flink-connector-jdbc-gaussdb 3.3.2-1.20 (Huawei MRS)**](https://github.com/huaweicloud-samples/database-gaussdb-flink-connector-jdbc/releases/tag/v3.3.2-1.20-mrs)
* [**flink-connector-jdbc-core 3.3.0-1.20**](https://repo1.maven.org/maven2/org/apache/flink/flink-connector-jdbc-core/3.3.0-1.20/)
* [**Flink**](https://flink.apache.org/downloads/)


## Use Cases ##

1.  Preparing the GaussDB Database Environment
    Purchase GaussDB instances and create database tables. (The following is an example of the test code.)
    
    Create the db test_db, schema player, and players tables in the GaussDB database.
    

```
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

2.  Flink SQL Application Scenarios

 *  Make source table
    Scenario description: Flink SQL reads gaussdb players data and writes the data to the printsink table.
    

```
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

**Execution success:**
![img.png](docs/image/scenario01.png)	

 *  To make a result table
    Scenario description: Flink SQL reads data from the gaussdb players_source table and writes the data to the gaussdb players table.
    

```
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

**Execution success:**
![img.png](docs/image/scenario02.png)	

 *  Creating a dimension table
    Scenario description: Flink SQL reads data from the gaussdb players_info table, joins the gaussdb dimension table players, and writes the data to the player_detail result table.
    

```
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

**Execution success:**
![img.png](docs/image/scenario03.png)	

**Notes:**

1.  GaussDB Driver Selection: Select the driver version based on the JDK version in the Flink cluster environment. 
2.  Source code repository address:[**flink-connector-jdbc-gaussdb**](https://github.com/HuaweiCloudDeveloper/gaussdb-flink-connector-jdbc)	,[**flink-connector-jdbc-core**](https://github.com/apache/flink-connector-jdbc)	
3.  This document describes Flink [Table API Connectors](https://nightlies.apache.org/flink/flink-docs-release-1.20/zh/docs/connectors/table/jdbc/)	usage. For Flink [DataStream Connectors](https://nightlies.apache.org/flink/flink-docs-release-1.20/zh/docs/connectors/datastream/jdbc/) usage see the official website.
