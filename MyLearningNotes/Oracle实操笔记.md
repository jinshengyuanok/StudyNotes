# Oracle实操笔记

## 1. 表空间及用户

### 1.1 创建表空间

1. 创建表空间

```plsql
create tablespace docmanagement
datafile 'C:\oracle\oradata\tt\docmanagement.dbf' --dbf文件位置
size 500M 
autoextend on next 100M 
maxsize unlimited;
```

2. 创建临时表空间

```plsql
create temporary tablespace temporary_docmanagement
tempfile 'C:\oracle\oradata\tt\docmanagement_temp.dbf' 
size 500M 
autoextend on 
next 100M maxsize unlimited
extent management local;
```

3. 表空间相关信息查看

```plsql

---1.表空间信息查看
select * from dba_tablespaces; ---查看表空间
select * from dba_data_files; --查看数据库文件位置
select * from dba_free_space;  
---2.临时表空间信息查看
select * from dba_temp_files;
select * from dba_temp_free_space; 

---修改表的表空间
select 'alter table  ' || TABLE_NAME || '  move tablespace docmanagement;'
  from USER_TABLES UT
 where UT.TABLESPACE_NAME = 'USERS'
 

--查询当前用户下在 USERS 表空间中的所有索引 ,并修改索引的表空间为 docmanagement
select 'alter index '|| index_name ||' rebuild tablespace docmanagement;' from user_indexes i
where i.tablespace_name = 'USERS'

--删除表空间及数据库文件
drop tablespace tablespace_name including contents and datafiles;
```



### 1.2 创建用户并指定默认表空间

1. 创建用户

```plsql
create user docmanagement identified by docmanagement
profile default
default tablespace docmanagement
temporary tablespace temporary_docmanagement
account unlock;
```

2. 用户授权

```plsql
grant connect,resource,dba to docmanagement
```

3. 用户授权相关

```plsql
--赋予用户权限
grant connect,resource to username ; 
grant create any sequence to username ; 
grant create any table to username ; 
grant delete any table to username ; 
grant insert any table to username ; 
grant select any table to username ; 
grant unlimited tablespace to username ; 
grant execute any procedure to username ; 
grant update any table to username ; 
grant create any view to username ;
```

### 1.3 锁表后解表

```plsql
--锁表查询SQL
SELECT object_name, machine, s.sid, s.serial#
  FROM gv$locked_object l, dba_objects o, gv$session s
 WHERE l.object_id　 = o.object_id
   AND l.session_id = s.sid;


--释放SESSION SQL: 
--alter system kill session 'sid, serial#'; 
ALTER system kill session '153, 138'; 

1 EOS_QRTZ_LOCKS  OK6YIJ9CUWNMIJE 144 96
2 EOS_QRTZ_LOCKS  OK6YIJ9CUWNMIJE 141 10
3 EOS_QRTZ_LOCKS  OK6YIJ9CUWNMIJE 153 138

```







## 2.文件导入、导出dump文件操作

Oracle中导出dmp文件导出、导入有三种主要的方式

- 完全模式：全库导出、导入
- 用户模式：按用户导出、导入
- 表模式 ：按表导出、导入

### 2.1 使用EXP命令导出dump文件

#### 1. 完全模式

```plsql
EXP 用户名/密码@网络服务名 FULL=Y FILE=路径/文件名.dmp LOG=路径/文件名.log
--如：
exp testdb/testdb@orcl file=C:\full.DMP log=C:\full.log full=Y   buffer=64000 
```

#### 2. 用户模式

```plsql
-- 按用户导出
EXP 用户名/密码@网络服务名 OWNERS=(user1，user2,…) FILE=路径/文件名.dmp LOG=路径/文件名.log
```

#### 3.  表模式

```plsql
--1.指定表导出
EXP 用户名/密码@网络服务名 TABLES=(table1，table2，…) FILE=路径/文件名.dmp LOG=路径/文件名.log
        
--2.导出时不导出表的数据
EXP 用户名/密码@网络服务名 TABLES=(table1，table2，…) ROWS=N FILE=路径/文件名.dmp LOG=路径/文件名.log

--3.导出表时加入对数据的要求
EXP 用户名/密码@网络服务名 TABLES=(tableName) FILE=路径/文件名.dmp LOG=路径/文件名.log QUERY = \”WHERE 条件一 OR|AND 条件二\”
```

### 2.2 使用IMP命令导入dump文件

```plsql
--1.全库导入
IMP 用户名/密码@网络服务名 FULL=Y FILE=路径/文件名.dmp LOG=路径/文件名.log
 
--2.按用户导入（同名用户可以不指定用户）
IMP 用户名/密码@网络服务名 FILE=路径/文件名.dmp FROMUSER=导出的用户名 TOUSER=导入的用户名 LOG=路径/文件名.log
 
--3.指定表导入
IMP 用户名/密码@网络服务名 TABLES=(table1，table2，…)FILE=路径/文件名.dmp FROMUSER=导出的用户名 TOUSER=导入的用户名 LOG=路径/文件名.log ignore=y 
```





### 2.3 Oracle11g中使用exp命令导出数据库时，默认不会导出空表

```plsql
【原因】：
Oracle11g的新特性，默认对空表不分配segment，即当数据库表中的数据条数是0时不分配segment，故使用exp导出Oracle11g数据库时，空表不会导出。

【解决方法】：
1.分析用户下的所有表：将该sql语句查询出的结果中的SQL都执行一遍
select 'analyze table '||table_name||' compute statistics;' from user_tables;
2.查询该用户下所有的空表：将该sql语句查询的结果中的SQL语句都执行一遍
select 'alter table '||table_name||' allocate extent;' from user_tables where num_rows=0;

【注：去客户现场部署时导入xxxx.dmp数据库文件,一定按下面方法执行：
	1.在Oracle数据库中使用dba身份中创建一个用户；
	2.用新建的用户将xxxx.dmp文件导入；
	3.一定记得先执行一下【解决方法】中的SQL，否则后期备份数据库可能会有问题，切记！切记！切记！
】

对于内容很多的时候clob打字段模糊查询很慢，整理一个小方法：

1，在查询的列上建索引
2，对于要查询的clob字段使用一下语句创建索引
 CREATE INDEX idx_zs_info_note ON zs_info(note) INDEXTYPE is CTXSYS.CONTEXT;  

3.查询的时候对于clob字段使用如下方法，不要使用like
 select * frominfo where contains(note,'XXXXX')>0  order by id desc 
还有一种方法可以使用dbms_lob.instr(note,'XXXX')>0 但是没有上面的快

CREATE INDEX index_literature_text on tb_literature_resource(text)
INDEXTYPE is CTXSYS.CONTEXT;  

```

1. 用SQL语句导出oracle中的存储过程和函数

```plsql
----用sql语句导出oracle中的存储过程和函数，若导出到C盘下，文件名称为proAndFun.sql
SPOOL 'C:/proAndFun.sql' replace
select case
         when LINE = 1 then
          'CREATE OR REPLACE ' || TEXT
         when LINE = MAX_LINE then
          TEXT || CHR(10) || '/'
         else
          TEXT
       end
  from USER_SOURCE A
  left join (select A.NAME, A.TYPE, max(LINE) MAX_LINE
               from USER_SOURCE A
              where type in ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY')
              group by A.NAME, A.TYPE) B
    on A.NAME || A.TYPE = B.NAME || B.TYPE
 where A.TYPE in ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
   and A.NAME in (select name
                    from ALL_SOURCE
                   where (type = 'PROCEDURE' or type = 'FUNCTION')
                     and OWNER = 'MPASS20180614' --用户名
                   group by name)
 order by a.NAME || a.TYPE, LINE;

```

### 2.4 java调用windows的命令提示符窗口导出Oracle数据库的dump文件

1. 属性文件相关配置信息

```properties
oracle_sid=orcl
jdbc_username=test_exp
jdbc_password=test_exp
exp_saveFilePath=D:/BackupDatabase
```

2. 文件导出类:OracleDumpFileProcess.java

```java
package com.rskytech.dataMove.action;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

public class OracleDumpFileProcess {
    public static void main(String[] args) {
        try {
            exportDumpFile();
        } catch (Exception e) {
            System.out.println("导出DUMP文件时出错了哦!!!");
            e.printStackTrace();
        }
    }

    /**
     * 读取属性文件相关配置导出数据
     *
     * @throws Exception
     */
    public static void exportDumpFile() throws Exception {
        Properties properties = new Properties();
        InputStream inStream = OracleDumpFileProcess.class.getResourceAsStream("expOrImpDumpFile.properties");
        properties.load(inStream);//加载资源文件
        String jdbc_username = properties.getProperty("jdbc_username");
        String jdbc_password = properties.getProperty("jdbc_password");
        String exp_saveFilePath = properties.getProperty("exp_saveFilePath");
        String oracle_sid = properties.getProperty("oracle_sid");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String f = sdf.format(new Date());
        String fileName = exp_saveFilePath + "/" + f + ".dmp";
        String exportDumpSyntax = "exp " + jdbc_username + "/" + jdbc_password + "@" + oracle_sid + " file=" + fileName;

        //文件存放目录不存在则创建
        File saveFile = new File(exp_saveFilePath);
        if (!saveFile.exists()) {// 如果目录不存在
            saveFile.mkdirs();// 创建文件夹
        }
        boolean finalResult = exportDatabaseTool(exportDumpSyntax);
        System.out.println("最终结果：" + finalResult);
    }

    
    /**
     * 调用cmd进程的方法
     * @param expOrImpSyntax  导出或导入语法
     * @return
     * @throws InterruptedException
     */
    public static boolean exportDatabaseTool(String expOrImpSyntax) throws InterruptedException {
        try {
            final Process process = Runtime.getRuntime().exec(expOrImpSyntax);
            //处理InputStream的线程
            new Thread() {
                @Override
                public void run() {
                    BufferedReader in = new BufferedReader(new InputStreamReader(process.getInputStream()));
                    processReadLine(in);
                }
            }.start();
            //处理ErrorStream的线程
            new Thread() {
                @Override
                public void run() {
                    BufferedReader err = new BufferedReader(new InputStreamReader(process.getErrorStream()));
                    processReadLine(err);
                }
            }.start();
            if (process.waitFor() == 0) {
                return true;
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    
    /**
     * 读取每一行的信息,输出到控制台中
     * @param bufferedReader
     */
    private static void processReadLine(BufferedReader bufferedReader) {
        String line;
        try {
            while ((line = bufferedReader.readLine()) != null) {
                System.out.println("output: " + line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                bufferedReader.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}

```







## 3. 索引相关

### 3.1 给CLOB字段建立索引

```plsql
---clob 字段创建索引
CREATE INDEX indexName on tableName(filedName)
INDEXTYPE is CTXSYS.CONTEXT;  
```

## 4. Oracle内置角色connect与resource的权限

1. 授权相关提示：

**`【注意：在存储过程或函数中，不同用户之间访问对方的表时,需要管理员先授权，否则在编译存储过程或函数时，提示表或视图不存在的现象】`**

如A用户想要访问dba_objects对象的查询权限时，必须由超级管理员先授权：

```sql
---管理员sys
grant select on dba_objects to A;

--实例函数：将fromUser用户所有表的查询权限赋予toUser用户，函数如下
create or replace function fun_export_DDL_auth(fromUser in varchar2,
                                               toUser   in varchar2)
  return integer is
  v_result integer := 0;
  v_sql    varchar2(200);
begin
  for i in (select t.OBJECT_NAME
              from dba_objects t
             where t.OBJECT_TYPE = 'TABLE'
               and t.OWNER = fromUser) loop
    v_sql := 'grant select on ' || fromUser || '.' || i.object_name ||
             ' to ' || toUser;
    execute immediate v_sql;
    v_result := 1;
  end loop;
  return(v_result);
end;

```



2. 各个权限授权语句

```plsql

首先用一个命令赋予user用户connect角色和resource角色：
grant connect,resource to user;
运行成功后用户包括的权限:
CONNECT角色： --是授予最终用户的典型权利，最基本的
ALTER SESSION --修改会话
CREATE CLUSTER --建立聚簇
CREATE DATABASE LINK --建立数据库链接
CREATE SEQUENCE --建立序列
CREATE SESSION --建立会话
CREATE SYNONYM --建立同义词
CREATE VIEW --建立视图

RESOURCE 角色： --是授予开发人员的
CREATE CLUSTER --建立聚簇
CREATE PROCEDURE --建立过程
CREATE SEQUENCE --建立序列
CREATE TABLE --建表
CREATE TRIGGER --建立触发器
CREATE TYPE --建立类型

从dba_sys_privs里可以查到（注意这里必须以DBA角色登录）:
select grantee,privilege from dba_sys_privs
where grantee='RESOURCE' order by privilege;

GRANTEE PRIVILEGE
------------ ----------------------
RESOURCE CREATE CLUSTER
RESOURCE CREATE INDEXTYPE
RESOURCE CREATE OPERATOR
RESOURCE CREATE PROCEDURE
RESOURCE CREATE SEQUENCE
RESOURCE CREATE TABLE
RESOURCE CREATE TRIGGER
RESOURCE CREATE TYPE

=================================================
一、何为角色？
　　我在前面的篇幅中说明权限和用户。慢慢的在使用中你会发现一个问题：如果有一组人，他们的所需的权限是一样的，当对他们的权限进行管理的时候会很不方便。因为你要对这组中的每个用户的权限都进行管理。
　　有一个很好的解决办法就是：角色。角色是一组权限的集合，将角色赋给一个用户，这个用户就拥有了这个角色中的所有权限。那么上述问题就很好处理了，只要第一次将角色赋给这一组用户，接下来就只要针对角色进行管理就可以了。
　　以上是角色的一个典型用途。其实，只要明白：角色就是一组权限的集合。下面分两个部门来对oracle角色进行说明。
二、系统预定义角色
　　预定义角色是在数据库安装后，系统自动创建的一些常用的角色。下介简单的介绍一下这些预定角色。角色所包含的权限可以用以下语句查询：
sql>select * from role_sys_privs where role='角色名';
１．CONNECT, RESOURCE, DBA
这些预定义角色主要是为了向后兼容。其主要是用于数据库管理。oracle建议用户自己设计数据库管理和安全的权限规划，而不要简单的使用这些预定角色。将来的版本中这些角色可能不会作为预定义角色。
２．DELETE_CATALOG_ROLE， EXECUTE_CATALOG_ROLE， SELECT_CATALOG_ROLE
这些角色主要用于访问数据字典视图和包。
３．EXP_FULL_DATABASE， IMP_FULL_DATABASE
这两个角色用于数据导入导出工具的使用。
４．AQ_USER_ROLE， AQ_ADMINISTRATOR_ROLE
AQ:Advanced Query。这两个角色用于oracle高级查询功能。
５．SNMPAGENT
用于oracle enterprise manager和Intelligent Agent
６．RECOVERY_CATALOG_OWNER
用于创建拥有恢复库的用户。关于恢复库的信息，参考oracle文档《Oracle9i User-Managed Backup and Recovery Guide》
７．HS_ADMIN_ROLE
A DBA using Oracle's heterogeneous services feature needs this role to access appropriate tables in the data dictionary.
二、管理角色
1.建一个角色
sql>create role role1;
2.授权给角色
sql>grant create any table,create procedure to role1;
3.授予角色给用户
sql>grant role1 to user1;
4.查看角色所包含的权限
sql>select * from role_sys_privs;
5.创建带有口令以角色(在生效带有口令的角色时必须提供口令)
sql>create role role1 identified by password1;
6.修改角色：是否需要口令
sql>alter role role1 not identified;
sql>alter role role1 identified by password1;
7.设置当前用户要生效的角色
(注：角色的生效是一个什么概念呢？假设用户a有b1,b2,b3三个角色，那么如果b1未生效，则b1所包含的权限对于a来讲是不拥有的，只有角色生效了，角色内的权限才作用于用户，最大可生效角色数由参数MAX_ENABLED_ROLES设定；在用户登录后，oracle将所有直接赋给用户的权限和用户默认角色中的权限赋给用户。）
sql>set role role1;//使role1生效
sql>set role role,role2;//使role1,role2生效
sql>set role role1 identified by password1;//使用带有口令的role1生效
sql>set role all;//使用该用户的所有角色生效
sql>set role none;//设置所有角色失效
sql>set role all except role1;//除role1外的该用户的所有其它角色生效。
sql>select * from SESSION_ROLES;//查看当前用户的生效的角色。
8.修改指定用户，设置其默认角色
sql>alter user user1 default role role1;
sql>alter user user1 default role all except role1;
详见oracle参考文档
9.删除角色
sql>drop role role1;
角色删除后，原来拥用该角色的用户就不再拥有该角色了，相应的权限也就没有了。

============================================================

一、权限分类：
系统权限：系统规定用户使用数据库的权限。（系统权限是对用户而言)。
实体权限：某种权限用户对其它用户的表或视图的存取权限。（是针对表或视图而言的）。

二、系统权限管理：
1、系统权限分类：
DBA: 拥有全部特权，是系统最高权限，只有DBA才可以创建数据库结构。

RESOURCE:拥有Resource权限的用户只可以创建实体，不可以创建数据库结构。

CONNECT:拥有Connect权限的用户只可以登录Oracle，不可以创建实体，不可以创建数据库结构。

对于普通用户：授予connect, resource权限。
对于DBA管理用户：授予connect，resource, dba权限。

2、系统权限授权命令：
[系统权限只能由DBA用户授出：sys, system(最开始只能是这两个用户)]
授权命令：SQL> grant connect, resource, dba to 用户名1 [,用户名2]...;

[普通用户通过授权可以具有与system相同的用户权限，但永远不能达到与sys用户相同的权限，system用户的权限也可以被回收。]

例：
SQL> connect system/manager
SQL> Create user user50 identified by user50;
SQL> grant connect, resource to user50;

查询用户拥有哪里权限：
SQL> select * from dba_role_privs;
SQL> select * from dba_sys_privs;
SQL> select * from role_sys_privs;

删除用户：SQL> drop user 用户名 cascade; //加上cascade则将用户连同其创建的东西全部删除

3、系统权限传递：
增加WITH ADMIN OPTION选项，则得到的权限可以传递。

SQL> grant connect, resorce to user50 with admin option; //可以传递所获权限。

4、系统权限回收：系统权限只能由DBA用户回收
命令：SQL> Revoke connect, resource from user50;

说明：

1）如果使用WITH ADMIN OPTION为某个用户授予系统权限，那么对于被这个用户授予相同权限的所有用户来说，取消该用户的系统权限并不会级联取消这些用户的相同权限。

2）系统权限无级联，即A授予B权限，B授予C权限，如果A收回B的权限，C的权限不受影响；系统权限可以跨用户回收，即A可以直接收回C用户的权限。

三、实体权限管理
1、实体权限分类：select, update, insert, alter, index, delete, all //all包括所有权限
execute //执行存储过程权限

user01:
SQL> grant select, update, insert on product to user02;
SQL> grant all on product to user02;

user02:
SQL> select * from user01.product;

// 此时user02查user_tables，不包括user01.product这个表，但如果查all_tables则可以查到，因为他可以访问。

2. 将表的操作权限授予全体用户：
SQL> grant all on product to public; // public表示是所有的用户，这里的all权限不包括drop。

[实体权限数据字典]:
SQL> select owner, table_name from all_tables; // 用户可以查询的表
SQL> select table_name from user_tables; // 用户创建的表
SQL> select grantor, table_schema, table_name, privilege from all_tab_privs; // 获权可以存取的表（被授权的）
SQL> select grantee, owner, table_name, privilege from user_tab_privs;   // 授出权限的表(授出的权限)

3. DBA用户可以操作全体用户的任意基表(无需授权，包括删除)：
DBA用户：
SQL> Create table stud02.product(
id number(10),
name varchar2(20));
SQL> drop table stud02.emp;
SQL> create table stud02.employee
as
select * from scott.emp;

4. 实体权限传递(with grant option)：
user01:
SQL> grant select, update on product to user02 with grant option; // user02得到权限，并可以传递。

5. 实体权限回收：
user01:
SQL>Revoke select, update on product from user02; //传递的权限将全部丢失。

说明

1）如果取消某个用户的对象权限，那么对于这个用户使用WITH GRANT OPTION授予权限的用户来说，同样还会取消这些用户的相同权限，也就是说取消授权时级联的。

Oracle 用户管理
一、创建用户的Profile文件
SQL> create profile student limit // student为资源文件名
FAILED_LOGIN_ATTEMPTS 3 //指定锁定用户的登录失败次数
PASSWORD_LOCK_TIME 5 //指定用户被锁定天数
PASSWORD_LIFE_TIME 30 //指定口令可用天数

二、创建用户
SQL> Create User username
Identified by password
Default Tablespace tablespace
Temporary Tablespace tablespace
Profile profile
Quota integer/unlimited on tablespace;

例:
SQL> Create user acc01
identified by acc01   // 如果密码是数字，请用双引号括起来
default tablespace account
temporary tablespace temp
profile default
quota 50m on account;
SQL> grant connect, resource to acc01;
查询用户缺省表空间、临时表空间
SQL> select username, default_tablespace, temporary_tablespace from dba_users;
查询系统资源文件名：
SQL> select * from dba_profiles;
资源文件类似表，一旦创建就会保存在数据库中。
SQL> select username, profile, default_tablespace, temporary_tablespace from dba_users;

SQL> create profile common limit
failed_login_attempts 5
idle_time 5;

SQL> Alter user acc01 profile common;

三、修改用户：
SQL> Alter User 用户名
Identified 口令
Default Tablespace tablespace
Temporary Tablespace tablespace
Profile profile
Quota integer/unlimited on tablespace;

1、修改口令字：
SQL>Alter user acc01 identified by "12345";

2、修改用户缺省表空间：
SQL> Alter user acc01 default tablespace users;

3、修改用户临时表空间
SQL> Alter user acc01 temporary tablespace temp_data;

4、强制用户修改口令字：
SQL> Alter user acc01 password expire;

5、将用户加锁
SQL> Alter user acc01 account lock; // 加锁
SQL> Alter user acc01 account unlock; // 解锁

四、删除用户
SQL>drop user 用户名; //用户没有建任何实体
SQL> drop user 用户名 CASCADE; // 将用户及其所建实体全部删除

*1. 当前正连接的用户不得删除。

五、监视用户：
1、查询用户会话信息：
SQL> select username, sid, serial#, machine from v$session;

2、删除用户会话信息：
SQL> Alter system kill session 'sid, serial#';

3、查询用户SQL语句：
SQL> select user_name, sql_text from v$open_cursor;

Oracle 角色管理

一、何为角色
　　角色。角色是一组权限的集合，将角色赋给一个用户，这个用户就拥有了这个角色中的所有权限。

二、系统预定义角色
　　预定义角色是在数据库安装后，系统自动创建的一些常用的角色。下介简单的介绍一下这些预定角色。角色所包含的权限可以用以下语句查询：
sql>select * from role_sys_privs where role='角色名';

1．CONNECT, RESOURCE, DBA
这些预定义角色主要是为了向后兼容。其主要是用于数据库管理。oracle建议用户自己设计数据库管理和安全的权限规划，而不要简单的使用这些预定角色。将来的版本中这些角色可能不会作为预定义角色。

2．DELETE_CATALOG_ROLE， EXECUTE_CATALOG_ROLE， SELECT_CATALOG_ROLE
这些角色主要用于访问数据字典视图和包。

3．EXP_FULL_DATABASE， IMP_FULL_DATABASE
这两个角色用于数据导入导出工具的使用。

4．AQ_USER_ROLE， AQ_ADMINISTRATOR_ROLE
AQ:Advanced Query。这两个角色用于oracle高级查询功能。

5． SNMPAGENT
用于oracle enterprise manager和Intelligent Agent

6．RECOVERY_CATALOG_OWNER
用于创建拥有恢复库的用户。关于恢复库的信息，参考oracle文档《Oracle9i User-Managed Backup and Recovery Guide》

7．HS_ADMIN_ROLE
A DBA using Oracle's heterogeneous services feature needs this role to access appropriate tables in the data dictionary.

三、管理角色
1.建一个角色
sql>create role role1;

2.授权给角色
sql>grant create any table,create procedure to role1;

3.授予角色给用户
sql>grant role1 to user1;

4.查看角色所包含的权限
sql>select * from role_sys_privs;

5.创建带有口令以角色(在生效带有口令的角色时必须提供口令)
sql>create role role1 identified by password1;

6.修改角色：是否需要口令
sql>alter role role1 not identified;
sql>alter role role1 identified by password1;


7.设置当前用户要生效的角色
(注：角色的生效是一个什么概念呢？假设用户a有b1,b2,b3三个角色，那么如果b1未生效，则b1所包含的权限对于a来讲是不拥有的，只有角色生效了，角色内的权限才作用于用户，最大可生效角色数由参数MAX_ENABLED_ROLES设定；在用户登录后，oracle将所有直接赋给用户的权限和用户默认角色中的权限赋给用户。）
sql>set role role1;//使role1生效
sql>set role role,role2;//使role1,role2生效
sql>set role role1 identified by password1;//使用带有口令的role1生效
sql>set role all;//使用该用户的所有角色生效
sql>set role none;//设置所有角色失效
sql>set role all except role1;//除role1外的该用户的所有其它角色生效。
sql>select * from SESSION_ROLES;//查看当前用户的生效的角色。

8.修改指定用户，设置其默认角色
sql>alter user user1 default role role1;
sql>alter user user1 default role all except role1;
详见oracle参考文档

9.删除角色
sql>drop role role1;
角色删除后，原来拥用该角色的用户就不再拥有该角色了，相应的权限也就没有了。

说明:
1)无法使用WITH GRANT OPTION为角色授予对象权限

2)可以使用WITH ADMIN OPTION 为角色授予系统权限,取消时不是级联

```

2. 批量授权

```sql
大概有三中办法：
1.单表授权
grant select any table to B;（此种方法控制不太精确，sys、system等一些表也能查看）

2.多表授权
grant select on A.tableName1 to public;
grant select on A.tableName2 to public;
.....................（有多少个表执行多少次），此方法比较麻烦

3.批量授权(隐式游标赋权)
select 'GRANT SELECT ON A.'||object_name||' to B;' from dba_objects where owner='A' and object_type='TABLE';
一般采用第3种方法，权限控制比较精细。

```



## 5. Oracle 中 with ... as 语句用法

1. with ... as语句

- with as 相当于虚拟视图。

  with as短语，也叫做子查询部分(subquery factoring)，可以让你做很多事情，定义一个sql片断，该sql片断会被整个sql语句所用到。有的时候，是为了让sql语句的可读性更高些，也有可能是在union all的不同部分，作为提供数据的部分。

- With查询语句不是以select开始的，而是以“WITH”关键字开头;    可认为在真正进行查询之前预先构造了一个临时表，之后便可多次使用它做进一步的分析和处理

- WITH Clause方法的优点

  增加了SQL的易读性，如果构造了多个子查询，结构会更清晰；更重要的是：“一次分析，多次使用”，这也是为什么会提供性能的地方，达到了“少读”的目标。

​     第一种使用子查询的方法表被扫描了两次，而使用WITH Clause方法，表仅被扫描一次。这样可以大大的提高数据分析和查询的效率。

​     另外，观察WITH Clause方法执行计划，其中“SYS_TEMP_XXXX”便是在运行过程中构造的中间统计结果临时表。

```sql
--一个别名
with sqlOne as
 (select a.id, a.user_name from tb_user a)
select * from sqlOne
--多个别名
with sqlOne as
 (select a.id from tb_user a),
sqlTwo as
 (select a.id, a.user_name from tb_user a)
select * from sqlOne t1, sqlTwo t2 where t1.id = t2.id
```

## 6. 存储过程

1. 九九乘法口诀表plsql块

```sql
begin
  for i in 1 .. 9 loop
    for j in 1 .. i loop
      dbms_output.put(j || '*' || i || '=' || i * j || '  ');
    end loop;
    dbms_output.put_line('');
  end loop;
  ---反向输出(主要用到了reverse函数)，与上面形成一个三角形
  for i in reverse 1 .. 9 loop
    for j in 1 .. i loop
      dbms_output.put(j || '*' || i || '=' || i * j || '  ');
    end loop;
    dbms_output.put_line('');
  end loop;
end;
--执行结果：
1*1=1  
1*2=2  2*2=4  
1*3=3  2*3=6  3*3=9  
1*4=4  2*4=8  3*4=12  4*4=16  
1*5=5  2*5=10  3*5=15  4*5=20  5*5=25  
1*6=6  2*6=12  3*6=18  4*6=24  5*6=30  6*6=36  
1*7=7  2*7=14  3*7=21  4*7=28  5*7=35  6*7=42  7*7=49  
1*8=8  2*8=16  3*8=24  4*8=32  5*8=40  6*8=48  7*8=56  8*8=64  
1*9=9  2*9=18  3*9=27  4*9=36  5*9=45  6*9=54  7*9=63  8*9=72  9*9=81  
1*9=9  2*9=18  3*9=27  4*9=36  5*9=45  6*9=54  7*9=63  8*9=72  9*9=81  
1*8=8  2*8=16  3*8=24  4*8=32  5*8=40  6*8=48  7*8=56  8*8=64  
1*7=7  2*7=14  3*7=21  4*7=28  5*7=35  6*7=42  7*7=49  
1*6=6  2*6=12  3*6=18  4*6=24  5*6=30  6*6=36  
1*5=5  2*5=10  3*5=15  4*5=20  5*5=25  
1*4=4  2*4=8  3*4=12  4*4=16  
1*3=3  2*3=6  3*3=9  
1*2=2  2*2=4  
1*1=1 
```

2. SQL*Plus 或者 PL/SQL Developer查看存储过程编译错误

```sql
在 SQL *Plus 或者 PL/SQL Developer 的 Command Windows 中，
1. 可以查看到存储过程具体错误；
show errors procedure procedure_name

2.查看函数错误
show errors function function_name

```

## 7. 函数

1. 将A用户下的**所有表**的**查询与新增权限**赋予B用户的函数

```plsql
create or replace function fun_export_DDL_auth(fromUser in varchar2,
                                               toUser   in varchar2)
  return integer is
  v_result integer := 0;
  v_sql    varchar2(200);
  /**
   * author: jinshengyuan
   * date: 2019-01-22
   * description: 将fromUser用户所有表的相关权限赋予toUser用户
  */
begin
  for i in (select t.OBJECT_NAME
              from dba_objects t
             where t.OBJECT_TYPE = 'TABLE'
               and t.OWNER = upper(fromUser)) loop
    v_sql := 'grant select,insert on ' || upper(fromUser) || '.' || i.object_name ||
             ' to ' || upper(toUser);
    execute immediate v_sql;
    v_result := 1;
  end loop;
  return(v_result);
end;
```

## 8. 工作中实际操作总结

### 8.1 Oracle分页总结

Oracle分页查询语句基本上可以按照本文给出的格式来进行套用。
Oracle分分页查询格式：

```plsql
select *
  from (select A.*, ROWNUM RN
          from (select * from TABLE_NAME) A
         where ROWNUM <= 40)
 where RN >= 21
 --注：最内层为要执行分页的SQL语句
```

其中最内层的查询SELECT * FROM TABLE_NAME表示不进行翻页的原始查询语句。ROWNUM <= 40和RN >= 21控制分页查询的每页的范围。

上面给出的这个Oracle分分页查询语句，在大多数情况拥有较高的效率。分页的目的就是控制输出结果集大小，将结果尽快的返回。在上面的分页查询语句中，这种考虑主要体现在WHERE ROWNUM <= 40这句上。

选择第21到40条记录存在两种方法，一种是上面例子中展示的在查询的第二层通过ROWNUM <= 40来控制最大值，在查询的最外层控制最小值。而另一种方式是去掉查询第二层的WHERE ROWNUM <= 40语句，在查询的最外层控制分页的最小值和最大值。查询语句如下：

```plsql
select *
  from (select A.*, ROWNUM RN from (select * from TABLE_NAME) A)
 where RN between 21 and 40
```

对比这两种写法，绝大多数的情况下，第一个查询的效率比第二个高得多。

这是由于CBO 优化模式下，Oracle可以将外层的查询条件推到内层查询中，以提高内层查询的执行效率。对于第一个查询语句，第二层的查询条件WHERE ROWNUM <= 40就可以被Oracle推入到内层查询中，这样Oracle查询的结果一旦超过了ROWNUM限制条件，就终止查询将结果返回了。

而第二个查询语句，由于查询条件BETWEEN 21 AND 40是存在于查询的第三层，而Oracle无法将第三层的查询条件推到最内层（即使推到最内层也没有意义，因为最内层查询不知道RN代表什么）。因此，对于第二个查询语句，Oracle最内层返回给中间层的是所有满足条件的数据，而中间层返回给最外层的也是所有数据。数据的过滤在最外层完成，显然这个效率要比第一个查询低得多。

上面分析的查询不仅仅是针对单表的简单查询，对于最内层查询是复杂的多表联合查询或最内层查询包含排序的情况一样有效。

分页计算方式：

```java
 //page是页数，rows是显示行数
 int page=2;
 int rows=5;                            
 List<Articles> list=a.select(page*rows+1，(page-1)*rows);
 //  sql语句：  select * from(select a.*,rownum rn from (select * from t_articles) a where rownum < 11) where rn>5
//第一个参数，对应着第一个rownum<11,第二个参数对应着rn>5
```

