# MySQL实操笔记

# 一.MySQL基础

## 1.安装及配置

1. MySQL 8.0.15 安装

- 官网地址：https://www.mysql.com/downloads/

- 社区版下载地址：https://dev.mysql.com/downloads/mysql/
- 下载好mysql-8.0.15-winx64.zip文件后解压到指定位置

2. 在解压后的文件中，这里为F:\mysql-8.0.15-winx64路径下，新建my.ini文件，内容如下

```ini
[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8
 
[mysqld]
# 设置3306端口
port = 3306
# 设置mysql的安装目录
basedir=F:\\mysql-8.0.15-winx64
# 设置 mysql数据库的数据的存放目录，MySQL 8+ 不需要以下配置，系统自己生成即可，否则有可能报错
# datadir=F:\\mysql-8.0.15-winx64\\data #8.0以下版本需要配置数据目录
# 允许最大连接数
max_connections=20
# 服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=utf8
# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
```

3. **一管理员身份**打开cmd命令提示符工具，并切换至F:\\mysql-8.0.15-winx64\bin目录下

```shell
cd F:\\mysql-8.0.15-winx64\bin
```

4. 初始化数据库

```shell
mysqld --initialize --console

此命令执行完后，会输出 root 用户的初始默认密码，如：
2019-02-17T07:42:09.954525Z 0 [System] [MY-013169] [Server] F:\mysql-8.0.15-winx64\bin\mysqld.exe (mysqld 8.0.15) initializing of server in progress as process 9972
2019-02-17T07:42:09.971649Z 0 [Warning] [MY-013242] [Server] --character-set-server: 'utf8' is currently an alias for the character set UTF8MB3, but will be an alias for UTF8MB4 in a future release. Please consider using UTF8MB4 in order to be unambiguous.
2019-02-17T07:42:24.953248Z 5 [Note] [MY-010454] [Server] A temporary password is generated for root@localhost: gem(&qH2I4t;
2019-02-17T07:42:31.295549Z 0 [System] [MY-013170] [Server] F:\mysql-8.0.15-winx64\bin\mysqld.exe (mysqld 8.0.15) initializing of server has completed
```

**注：**上面输出内容中【root@localhost: gem(&qH2I4t;】中的 **gem(&qH2I4t;**就是root用户的初始密码

5. 输入下面命令进行MySQL的安装

```shell
mysqld install
```

6. 启动MySQL服务

```shell
net start mysql
```

7. 登录MySQL数据库

```shell
mysql -h 主机名 -u 用户名 -p
```

参数说明：

- **-h** : 指定客户端所要登录的 MySQL 主机名, 登录本机(localhost 或 127.0.0.1)该参数可以省略;
- **-u** : 登录的用户名;
- **-p** : 告诉服务器将会使用一个密码来登录, 如果所要登录的用户名密码为空, 可以忽略此选项。

如果我们要登录本机的 MySQL 数据库，只需要输入以下命令即可：

8. 修改root用户的密码

```mysql
alter user 'root'@'localhost' identified by 'yuan';
```

## 2. 使用命令执行本地磁盘中的sql文件

1. 进入MySQL的安装目录的bin目录下执行下面命令

```mysql
mysql –u用户名 –p密码 –D数据库<【sql脚本文件路径全名】

如：mysql –u root –p 123456 -Dtest <C:\test.sql

注意：
1.如果在 sql 脚本文件中使用了 use 数据库，则 -D数据库 选项可以忽略
2.如果【Mysql的bin目录】中包含空格，则需要使用“”包含，如：“C:\Program Files\MySQL\bin\mysql” –u用户名 –p密码 –D数据库<【sql脚本文件路径全名】
3.如果 sql 没有创建数据库的语句，而且数据库管理中也没有该数据库，那么必须先用命令创建一个空的数据库。
```

2. 使用source命令执行

```mysql
mysql -u root -p  回车输入密码后，使用下面命令执行本地sql文件，如

mysql>source 【sql脚本文件的路径全名】 或 mysql>\. 【sql脚本文件的路径全名】，示例：
source C:\test.sql 或者 \. C:\test.sql
```



## 二. 存储过程与自定义函数

## 1. 存储过程



## 2. 自定义函数



官方文档：https://dev.mysql.com/doc/refman/8.0/en/create-procedure.html

1. 官网语法：

```mysql
CREATE
    [DEFINER = { user | CURRENT_USER }]
    PROCEDURE sp_name ([proc_parameter[,...]])
    [characteristic ...] routine_body

CREATE
    [DEFINER = { user | CURRENT_USER }]
    FUNCTION sp_name ([func_parameter[,...]])
    RETURNS type
    [characteristic ...] routine_body

proc_parameter:
    [ IN | OUT | INOUT ] param_name type

func_parameter:
    param_name type

type:
    Any valid MySQL data type

characteristic:
    COMMENT 'string'
  | LANGUAGE SQL
  | [NOT] DETERMINISTIC
  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
  | SQL SECURITY { DEFINER | INVOKER }

routine_body:
    Valid SQL routine statement
```

2. 自定义函数实例

```mysql
CREATE DEFINER=`root`@`localhost` FUNCTION `fun_one`() RETURNS varchar(50) CHARSET utf8
begin 
    declare c VARCHAR(50);
    select id from tb_user t where t.user_name="jinshengyuan" into c;
    return c;
end
```

3. 查看自定义函数的语句

```mysql
查看函数创建语句：
show create function 函数名;
查看所有函数：
show function status [like 'pattern'];
```

## 三. MySql执行计划(Explain)



# 四.Mysql主从复制(master/slave)

## 1. 复制原理

slave会从master读取binlog来进行数据同步，三步骤：

1. master将改变记录到二进制日志(binary log )。这些记录过程叫做二进制日事件(binary log events);
2. slave将master的binary log events 拷贝到它的中继日志(relay log);
3. slave重做中继日志中的事件，将改变应用到自己的数据库中。MySQL复制是异步的且是串行化的。

## 2.复制的基本原则

1. 每个slave只有一个master；
2. 每个slave只有一个唯一的服务器id(server-id);
3. 每个master可以有多个slave；

## 3.复制的最大问题--延时

## 4. 一主一从常见配置(MySQL 5.7.x)

要求：

- mysql版本一致且以后台服务运行，【大版本必须一致，小版本不要跨太多，最好大小本都一致】
- 主从配置在[mysqld]节点下，建议都小写

### 4.1 主机服务器配置

主库安装在Windows系统中,IP为：192.168.1.123

1. 修改主机my.ini配置文件

```mysql
1.主服务器id唯一【必须】
server-id=1
2.启用二进制日志【必须】
配置：log-bin=自己本地mysql安装目录/mysqlbin，如下：
log-bin=D:/zipsoftwareinstall/mysql-5.7.18-winx64/data/mysqlbin
3.启用错误日志【可选】加上这个有可能mysql服务启动不了，原因不明
配置：log-err=自己本地mysql安装目录/mysqlerr
log-err=D:/zipsoftwareinstall/mysql-5.7.18-winx64/data/mysqlerr
4.根目录【可选】
basedir=D:/zipsoftwareinstall/mysql-5.7.18-winx64
5.临时目录【可选】
tempdir=D:/zipsoftwareinstall/mysql-5.7.18-winx64
6.数据目录【可选】
datadir=D:/zipsoftwareinstall/mysql-5.7.18-winx64/data
7.主机，都写都可以
read-only=0
8.设置不要复制的数据库【可选】
binlog-ignore-db=mysql
9.设置需要复制的数据库【可选】
binlog-do-db=要复制的数据库名字
```

2. 主机上建立账户并授权给slave

```mysql
1.登录root账户
mysql -u root -p  回车输入密码

2.创建用户并授权
语句：
grant replication slave on *.* to 'jinshengyuan'@'从机数据库IP' identified by 'yuan';
如从机ip:192.168.154
grant replication slave on *.* to 'jinshengyuan'@'192.168.154' identified by 'yuan';
3.刷新权限
flush privileges;
5. 查询master(主机)状态【记录File与Position的值】
show master status;
或
show master status\G;//此方是以Key:Value格式显示
```

### 4.2 从机服务器配置

从机安装在CentOS7中的Docker容器中，从机IP：192.168.1.154

docker中安装MySQL：

1. 安装mysql

```shell
docker pull mysql:5.7.18
```

2. 注册并运行mysql服务

```shell
docker run -d --name mysql5718 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=yuan mysql:5.7.18
```

3. 启动mysql服务

```shell
docker start mysql5718
```

4. 在docker容器中安装vim编辑器

```shell
apt-get install vim;

注：如果出现下面情况则需要先  apt-get update 后再执行apt-get install vim;

root@aabc84720506:/# apt-get install vim;
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: Unable to locate package vim
```

5. 进入容器

```shell
docker exec -it mysql5718 /bin/bash
```

6. 进入容器后，**在容器内部**使用命令 cd /etc/mysql/ 进入到mysql目录下

```shell
cd /etc/mysql/
[root@localhost ~]# docker exec -it mysql5718 /bin/bash
root@aabc84720506:/# cd /etc/mysql/  
root@aabc84720506:/etc/mysql# ls -l
total 8
drwxr-xr-x. 1 root root   24 Jun 23  2017 conf.d
lrwxrwxrwx. 1 root root   24 Jun 23  2017 my.cnf -> /etc/alternatives/my.cnf
-rw-r--r--. 1 root root 1050 Mar 18  2017 my.cnf.fallback
-rw-r--r--. 1 root root  796 Mar 18  2017 mysql.cnf
drwxr-xr-x. 1 root root   24 Jun 23  2017 mysql.conf.d
```

7. **在容器内部**修改my.cnf文件，

```shell
使用 vim /etc/mysql/my.cnf 命令打开my.cnf文件，添加下面代码：
[mysqld]
#同一局域网内注意要唯一
server-id=2 
#开启二进制日志功能，可以随便取（关键）
log-bin=mysql-bin
```

8. 进入mysql

```shell
mysql -r root -p  回车后输入密码

root@aabc84720506:/# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.18 MySQL Community Server (GPL)

Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

9. 执行下面命令

```mysql
change master to master_host='192.168.1.123',master_user='jinshengyuan',master_password='yuan',master_log_file='mysqlbin.00004',master_log_pos=1696,master_connect_retry=30;

说明：
master_host ：Master的地址，指的是容器的独立ip,
可以通过docker inspect --format='{{.NetworkSettings.IPAddress}}' 容器名称|容器id查询容器的ip

master_port：Master的端口号，指的是容器的端口号

master_user：用于数据同步的用户

master_password：用于同步的用户的密码

master_log_file：指定 Slave 从哪个日志文件开始复制数据，即上文中提到的 File 字段的值

master_log_pos：从哪个 Position 开始读，即上文中提到的 Position 字段的值

master_connect_retry：如果连接失败，重试的时间间隔，单位是秒，默认是60秒

在Slave 中的mysql终端执行show slave status \G;用于查看主从同步状态。
```

10. 查看slave状态

```mysql
mysql> show slave status\G;
*************************** 1. row ***************************
               Slave_IO_State: 
                  Master_Host: 192.168.1.123
                  Master_User: jinshengyuan
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysqlbin.00004
          Read_Master_Log_Pos: 1395
               Relay_Log_File: aabc84720506-relay-bin.000001
                Relay_Log_Pos: 4
        Relay_Master_Log_File: mysqlbin.00004
             Slave_IO_Running: No
            Slave_SQL_Running: No
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 1395
              Relay_Log_Space: 154
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: NULL
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 0
                  Master_UUID: 
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: 
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
1 row in set (0.00 sec)

ERROR: 
No query specified
```

11. 启动从机服务器的复制功能

```mysql
mysql> start slave;
Query OK, 0 rows affected (0.03 sec)
```

13. 再次查看slave状态；

```mysql
show slave status\G;
```

14. 停止主从复制

```mysql
mysql> stop slave;
Query OK, 0 rows affected (0.03 sec)
```



**[注意] 执行9的命令后会出现下面错误及解决方法**

```shell
mysql> change master to master_host='192.168.1.123',master_user='jinshengyuan',master_password='yuan',master_lo
g_file='mysqlbin.00004',master_log_pos=1395;
ERROR 1794 (HY000): Slave is not configured or failed to initialize properly. You must at least set --server-id
 to enable either a master or a slave. Additional error messages can be found in the MySQL error log.
mysql> 
```

**解决方法**

1. drop 备份的ibd表

```mysql
use mysql；
drop table slave_master_info;
drop table slave_relay_log_info;
drop table slave_worker_info;
drop table innodb_index_stats;
drop table innodb_table_stats;
```

2. 重建

```mysql
mysql> source /usr/share/mysql/mysql_system_tables.sql
Query OK, 0 rows affected, 1 warning (0.00 sec)　
```

3. 重启数据库
4. 再次执行change master to ... 命令

```mysql
mysql> change master to master_host='192.168.1.123',master_user='jinshengyuan',master_password='yuan',master_log_file='mysqlbin.00004',maste
r_log_pos=1395;
Query OK, 0 rows affected, 2 warnings (0.07 sec)

mysql> 
```

## 5.一主一从常见配置(MySQL 8.0.x)

- 大部分配置跟5.7.x版本无区别，主要区别在于主机(master)创建用户与授权上

### 1. 主机配置

1. 创建用户

```mysql
mysql> create user 'wei'@'192.168.31.200'identified by 'wei';
Query OK, 0 rows affected (0.09 sec)
```

2. 授权

```mysql
mysql> grant replication slave on *.* to 'wei'@'192.168.31.200';
Query OK, 0 rows affected (0.04 sec)
```

3. 刷新权限

```mysql
mysql> flush privileges;
Query OK, 0 rows affected (0.18 sec)
```

4. 查看master状态

```mysql
mysql> show master status;
+-----------------+----------+--------------+------------------+-------------------+
| File            | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+-----------------+----------+--------------+------------------+-------------------+
| mysqlbin.000002 |      879 |              | mysql            |                   |
+-----------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

### 2. 从机配置

- 从机配置更5.7.x版本无区别,这里直接省略

