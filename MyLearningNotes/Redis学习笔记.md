# Redis

操作系统：Linux Centos 7

Redis版本：redis-5.0.3.tar.gz

## 一.下载与安装

查看centos 7 版本的命令

``` shell
查看系统版本的命令
1. cat /etc/redhat-release 
[root@localhost ~]# cat /etc/redhat-release 
CentOS Linux release 7.6.1810 (Core) 
2. rpm -q centos-release
[root@localhost ~]# rpm -q centos-release
centos-release-7-6.1810.2.el7.centos.x86_64

查看内核命令：
1.uname -a
[root@localhost ~]# uname -a
Linux localhost.localdomain 3.10.0-957.1.3.el7.x86_64 #1 SMP Thu Nov 29 14:49:43 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
2. cat /proc/version
[root@localhost ~]#  cat /proc/version
Linux version 3.10.0-957.1.3.el7.x86_64 (mockbuild@kbuilder.bsys.centos.org) 
(gcc version 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) ) #1 SMP Thu Nov 29 14:49:43 UTC 2018
```



### 1.下载

官网：https://redis.io/

### 2.安装

本文以redis-5.0.3.tar.gz版本为例

1. 将下载好的redis-5.0.3.tar.gz文件复制到/opt目录中
2. 解压：tar -zxvf redis-5.0.3.tar.gz
3. 在解压后的redis-5.0.3目录下执行make命令，如果gcc未找到，则会出现如下错误

``` shell
[root@localhost redis-5.0.3]# make
cd src && make all
make[1]: 进入目录“/opt/redis-5.0.3/src”
    CC Makefile.dep
make[1]: 离开目录“/opt/redis-5.0.3/src”
make[1]: 进入目录“/opt/redis-5.0.3/src”
rm -rf redis-server redis-sentinel redis-cli redis-benchmark redis-check-rdb redis-check-aof *.o *.gcda *.gcno *.gcov red
is.info lcov-html Makefile.dep dict-benchmark
(cd ../deps && make distclean)
make[2]: 进入目录“/opt/redis-5.0.3/deps”
(cd hiredis && make clean) > /dev/null || true
(cd linenoise && make clean) > /dev/null || true
(cd lua && make clean) > /dev/null || true
(cd jemalloc && [ -f Makefile ] && make distclean) > /dev/null || true
(rm -f .make-*)
make[2]: 离开目录“/opt/redis-5.0.3/deps”
(rm -f .make-*)
echo STD=-std=c99 -pedantic -DREDIS_STATIC='' >> .make-settings
echo WARN=-Wall -W -Wno-missing-field-initializers >> .make-settings
echo OPT=-O2 >> .make-settings
echo MALLOC=jemalloc >> .make-settings
echo CFLAGS= >> .make-settings
echo LDFLAGS= >> .make-settings
echo REDIS_CFLAGS= >> .make-settings
echo REDIS_LDFLAGS= >> .make-settings
echo PREV_FINAL_CFLAGS=-std=c99 -pedantic -DREDIS_STATIC='' -Wall -W -Wno-missing-field-initializers -O2 -g -ggdb   -I../
deps/hiredis -I../deps/linenoise -I../deps/lua/src -DUSE_JEMALLOC -I../deps/jemalloc/include >> .make-settings
echo PREV_FINAL_LDFLAGS=  -g -ggdb -rdynamic >> .make-settings
(cd ../deps && make hiredis linenoise lua jemalloc)
make[2]: 进入目录“/opt/redis-5.0.3/deps”
(cd hiredis && make clean) > /dev/null || true
(cd linenoise && make clean) > /dev/null || true
(cd lua && make clean) > /dev/null || true
(cd jemalloc && [ -f Makefile ] && make distclean) > /dev/null || true
(rm -f .make-*)
(echo "" > .make-cflags)
(echo "" > .make-ldflags)
MAKE hiredis
cd hiredis && make static
make[3]: 进入目录“/opt/redis-5.0.3/deps/hiredis”
gcc -std=c99 -pedantic -c -O3 -fPIC  -Wall -W -Wstrict-prototypes -Wwrite-strings -g -ggdb  net.c
make[3]: gcc：命令未找到
make[3]: *** [net.o] 错误 127
make[3]: 离开目录“/opt/redis-5.0.3/deps/hiredis”
make[2]: *** [hiredis] 错误 2
make[2]: 离开目录“/opt/redis-5.0.3/deps”
make[1]: [persist-settings] 错误 2 (忽略)
    CC adlist.o
/bin/sh: cc: 未找到命令
make[1]: *** [adlist.o] 错误 127
make[1]: 离开目录“/opt/redis-5.0.3/src”
make: *** [all] 错误 2
[root@localhost redis-5.0.3]# 
```

### 3 .解决gcc未找到的问题

gcc是Linux下的一个编译程序，是C程序的编译工具

解决方法：

#### 1.能连网直接使用命令安装(本文的安装方式)：

1. 使用yum install gcc-c++ 命令进行安装

``` shell
---> 软件包 kernel-headers.x86_64.0.3.10.0-957.1.3.el7 将被 安装
--> 解决依赖关系完成

依赖关系解决

=========================================================================================================================
 Package                         架构                   版本                               源                       大小
=========================================================================================================================
正在安装:
 gcc-c++                         x86_64                 4.8.5-36.el7                       base                    7.2 M
为依赖而安装:
 cpp                             x86_64                 4.8.5-36.el7                       base                    5.9 M
 gcc                             x86_64                 4.8.5-36.el7                       base                     16 M
 glibc-devel                     x86_64                 2.17-260.el7                       base                    1.1 M
 glibc-headers                   x86_64                 2.17-260.el7                       base                    683 k
 kernel-headers                  x86_64                 3.10.0-957.1.3.el7                 updates                 8.0 M
 libmpc                          x86_64                 1.0.1-3.el7                        base                     51 k
 libstdc++-devel                 x86_64                 4.8.5-36.el7                       base                    1.5 M
 mpfr                            x86_64                 3.1.1-4.el7                        base                    203 k

事务概要
=========================================================================================================================
安装  1 软件包 (+8 依赖软件包)

总下载量：41 M
安装大小：84 M
Is this ok [y/d/N]: y

如果出现下面内容则说明安装成功：
已安装:
  gcc-c++.x86_64 0:4.8.5-36.el7                                                                                         
作为依赖被安装:
  cpp.x86_64 0:4.8.5-36.el7              gcc.x86_64 0:4.8.5-36.el7                   glibc-devel.x86_64 0:2.17-260.el7 
  glibc-headers.x86_64 0:2.17-260.el7    kernel-headers.x86_64 0:3.10.0-957.1.3.el7  libmpc.x86_64 0:1.0.1-3.el7       
  libstdc++-devel.x86_64 0:4.8.5-36.el7  mpfr.x86_64 0:3.1.1-4.el7       

安装后使用下面命令查看版本
gcc -v

```

2. gcc安装后,再使用make命令安装，如果出现了下面错误,需要使用make distclean 命令清理下：

   zmalloc.h:50:31: 致命错误：jemalloc/jemalloc.h：没有那个文件或目录

``` shell
[root@localhost redis-5.0.3]# make
cd src && make all
make[1]: 进入目录“/opt/redis-5.0.3/src”
    CC Makefile.dep
make[1]: 离开目录“/opt/redis-5.0.3/src”
make[1]: 进入目录“/opt/redis-5.0.3/src”
    CC adlist.o
In file included from adlist.c:34:0:
zmalloc.h:50:31: 致命错误：jemalloc/jemalloc.h：没有那个文件或目录
 #include <jemalloc/jemalloc.h>
                               ^
编译中断。
make[1]: *** [adlist.o] 错误 1
make[1]: 离开目录“/opt/redis-5.0.3/src”
make: *** [all] 错误 2
[root@localhost redis-5.0.3]# 

解决方法：使用make distclean 清理后再make
```

3. 解决方法：使用make distclean 清理后再make
4. 在使用make安装，安装成功后，则会显示下面信息：

``` shell

Hint: It's a good idea to run 'make test' ;)

make[1]: 离开目录“/opt/redis-5.0.3/src”
[root@localhost redis-5.0.3]# 
```

5. make test可以不执行，如果执行make test ,有可能出现tcl未安装的情况，如下

``` shell
[root@localhost redis-5.0.3]# make test
cd src && make test
make[1]: 进入目录“/opt/redis-5.0.3/src”
    CC Makefile.dep
make[1]: 离开目录“/opt/redis-5.0.3/src”
make[1]: 进入目录“/opt/redis-5.0.3/src”
You need tcl 8.5 or newer in order to run the Redis test
make[1]: *** [test] 错误 1
make[1]: 离开目录“/opt/redis-5.0.3/src”
make: *** [test] 错误 2
[root@localhost redis-5.0.3]# 
```

6. 安装TCL

   TCL官网：http://www.linuxfromscratch.org/blfs/view/cvs/general/tcl.html

   tcl 安装步骤：

``` shell
--安装wget命令:yum -y install wget
--能连网就使用wget命令安装tcl
wget https://downloads.sourceforge.net/tcl/tcl8.6.9-src.tar.gz

1.然后使用解压命令将tcl8.6.9-src.tar.gz解压到/usr/local/目录下：
tar -zxvf tcl8.6.9-src.tar.gz -C /usr/local/ 
2. 执行命令：
[root@localhost]# cd /usr/local/tcl8.6.9/unix/
3. 执行命令
[root@localhost unix]# ./configure
4.执行命令：
[root@localhost unix]# make
5.执行命令：
[root@localhost unix]# make install

5.切换至目录下执行make test
[root@localhost ~]# cd /opt/redis-5.0.3
[root@localhost redis-5.0.3]# make test

如果test通过后会在最后输出 "所有测试都通过了，没有错误！"的信息,如下：
\o/ All tests passed without errors!
```

7. 使用make install 命令完成最终的安装

``` shell
切换至 redis-5.0.3目录下，输入 make instll 命令完成最终的安装，如下
[root@localhost ~]# cd /opt/redis-5.0.3
[root@localhost redis-5.0.3]# 
[root@localhost redis-5.0.3]# make install

输出如下信息表示安装成功：
[root@localhost redis-5.0.3]# make install
cd src && make install
make[1]: 进入目录“/opt/redis-5.0.3/src”

Hint: It's a good idea to run 'make test' ;)

    INSTALL install
    INSTALL install
    INSTALL install
    INSTALL install
    INSTALL install
make[1]: 离开目录“/opt/redis-5.0.3/src”
[root@localhost redis-5.0.3]#
```

#### 2.不能连网：从安装镜像中找到对应的包进行安装

（安装过程忽略）

``` shell
从安装Linux的安装镜像文件中找到对应的rpm文件(上网查对应文件），然后使用下面命令进行安装
rpm -ivh xxxx.rpm 回车
```

## 二.redis.conf及hello world

Redis安装完成后在 /usr/local/bin/目录下可查看

``` shell
[root@MiWiFi-R1CL-srv]# cd /usr/local/bin/
[root@MiWiFi-R1CL-srv bin]# ls -l
总用量 32716
-rwxr-xr-x. 1 root root 4366576 1月   3 21:06 redis-benchmark
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-check-aof
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-check-rdb
-rwxr-xr-x. 1 root root 4801824 1月   3 21:06 redis-cli
lrwxrwxrwx. 1 root root      12 1月   3 21:06 redis-sentinel -> redis-server
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-server
-rwxr-xr-x. 1 root root   30291 1月   3 20:59 sqlite3_analyzer
-rwxr-xr-x. 1 root root    8664 1月   3 20:59 tclsh8.6

```



### 1.redis.conf文件

1. 安装完成后，先将redis-5.0.3目录下的redis.conf文件拷贝到其他地放进行修改

``` shell
1.在根目录下新建myredis目录：
mkdir myredis
2.redis.conf文件拷贝：
cp /opt/redis-5.0.3/redis.conf /myredis/
```

2. /myredis/redis.conf文件修改

``` shell
vim /myredis/redis.conf 打开文件，然后找到daemonize no，【shift+$ 移动到行末】
1.将daemonize no 修改为 daemonize yes
```

### 2.启动redis

``` shell
1.进入bin目录下
[root@MiWiFi-R1CL-srv ~]# cd /usr/local/bin/
[root@MiWiFi-R1CL-srv bin]# ls -l
总用量 32716
-rwxr-xr-x. 1 root root 4366576 1月   3 21:06 redis-benchmark
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-check-aof
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-check-rdb
-rwxr-xr-x. 1 root root 4801824 1月   3 21:06 redis-cli
lrwxrwxrwx. 1 root root      12 1月   3 21:06 redis-sentinel -> redis-server
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-server
-rwxr-xr-x. 1 root root   30291 1月   3 20:59 sqlite3_analyzer
-rwxr-xr-x. 1 root root    8664 1月   3 20:59 tclsh8.6
[root@MiWiFi-R1CL-srv bin]

2.用命令查看后台redis服务有么有启动
[root@MiWiFi-R1CL-srv bin]# ps -ef|grep redis
root     27171 27146  0 21:45 pts/0    00:00:00 grep --color=auto redis

3.启动redis服务，这里不启动出厂默认redis.conf,而是启动我们自己配置的 /myredis/redis.conf
[root@MiWiFi-R1CL-srv bin]# redis-server /myredis/redis.conf 
27172:C 03 Jan 2019 21:47:34.945 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
27172:C 03 Jan 2019 21:47:34.945 # Redis version=5.0.3, bits=64, commit=00000000, modified=0, pid=27172, just started
27172:C 03 Jan 2019 21:47:34.945 # Configuration loaded

4.启动redis客户端
[root@MiWiFi-R1CL-srv bin]# redis-cli -p 6379
127.0.0.1:6379> 
输入ping命令验证
127.0.0.1:6379> ping
PONG
127.0.0.1:6379> 

5.输出hello world
127.0.0.1:6379> set k1 "hell world"
OK
127.0.0.1:6379> get k1
"hell world"
127.0.0.1:6379> 

6.再次查看redis后台进程有么有启动
[root@MiWiFi-R1CL-srv ~]# ps -ef|grep redis
root     27173     1  0 21:47 ?        00:00:00 redis-server 127.0.0.1:6379
root     27179 27146  0 21:49 pts/0    00:00:00 redis-cli -p 6379
root     27199 27181  0 21:52 pts/1    00:00:00 grep --color=auto redis
```

### 3.关闭redis服务

```shell
命令：SHUTDOWN [NOSAVE|SAVE]

1.关闭redis服务并退出
127.0.0.1:6379> SHUTDOWN
not connected> exit

2.关闭后查看后台redis服务有没有
[root@MiWiFi-R1CL-srv bin]# ps -ef|grep redis
root     27203 27146  0 22:00 pts/0    00:00:00 grep --color=auto redis
[root@MiWiFi-R1CL-srv bin]# 
```

## 三.Redis启动杂项基础知识

### 1. redis-benchmark [性能测试]

``` shell
1.进入bin目录
[root@MiWiFi-R1CL-srv bin]# ls -l /usr/local/bin 
总用量 32720
-rw-r--r--. 1 root root     112 1月   3 21:58 dump.rdb
-rwxr-xr-x. 1 root root 4366576 1月   3 21:06 redis-benchmark
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-check-aof
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-check-rdb
-rwxr-xr-x. 1 root root 4801824 1月   3 21:06 redis-cli
lrwxrwxrwx. 1 root root      12 1月   3 21:06 redis-sentinel -> redis-server
-rwxr-xr-x. 1 root root 8090008 1月   3 21:06 redis-server
-rwxr-xr-x. 1 root root   30291 1月   3 20:59 sqlite3_analyzer
-rwxr-xr-x. 1 root root    8664 1月   3 20:59 tclsh8.6
[root@MiWiFi-R1CL-srv bin]#  redis-benchmark 
```

1. 单进程：单进程模型来处理客户端的请求。对读写等事件的响应是通过epoll函数的包装来做到的。Redis的实际处理速度完全依靠主进程的执行效率【Epoll是Linux内核为处理大批量文件描述符而作了改进的epoll,是Linux下多路复用IO接口select/poll的增强版本，它能显著提高程序在大量并发连接中只有少量活跃的情况下的系统CPU利用率。】
2. 出厂默认16个数据库:库的顺序类似数组下标从零开始，初始默认使用零号库
3. select命令切换数据库：select index，index为库的下标，index=库总数-1
4. DBSIZE - :查看当前数据库下key的数量
5. keys pattern: 如 keys * 查看当前库下所有的key，keys k? 查看以k开头的所有key
6. FLUSHDB [ASYNC] :清空当期库
7. FLUSHALL [ASYNC]:通杀所有库
8. 统一密码管理：16个库都使用同一个密码，要么都OK，要么一个也连不上
9. 默认端口：6379
10. Redis索引都是从0开始

## 四.五大数据类型

### 1.Key(键)

``` shell
1.keys pattern  查看当期库所有的key
127.0.0.1:6379> keys *
1) "k1"
2) "k2"
3) "k3"

2.set key value [expiration EX seconds|PX milliseconds] [NX|XX]：设置key及key的值
127.0.0.1:6379> set k1 "Hello World!"
OK

3.get key :根据key获取值
127.0.0.1:6379> get k1
"Hello World!"

4.EXISTS key [key ...]  判断某个key或某些key是否存在，存在则返回存在key的个数，不存在则返回 0
127.0.0.1:6379> exists k1 k2
(integer) 2

5. move key db  将某个key从当前库移动到其他库中，移动后当前库中就不存在了，成功返回1，失败返回0
【注：如果其他库已经存在当前key则会移动失败，直接返回0】
127.0.0.1:6379> move k3 1
(integer) 1

6.EXPIRE key seconds 设置key的过期时间,key过期后就不存在了，单位:秒
127.0.0.1:6379> EXPIRE k3 10
(integer) 0

7. TTL key 查看key还有多少秒过期，返回-1：表示永不过期；返回-2：表示已经过期
127.0.0.1:6379> TTL k1
(integer) -1

8. TYPE key  查看key的数据类型
127.0.0.1:6379> type k1
string

9. DEL key [key ...] 删除key或多个key
127.0.0.1:6379> DEL k2
(integer) 1


```

### 2.字符串(String)

1.单值单value

``` shell
1.set/get/append/strlen.....

2.incr/incrby/decr/decrby 一定操作的是数字才能进行加与减
INCRBY key  每次+1
INCRBY key increment 每次+increment
DECRBY key 每次-1
DECRBY key decrement  每次-decrement

3.GETRANGE key start end/SETRANGE key offset value
GETRANGE: 获取指定区间范围的值，类似于java中的substring
127.0.0.1:6379> GETRANGE k1 0 -1   0到-1表示全部
"hello world"

SETRANGE: 设置指定区间范围的值，设值key的值，从offset 开始设置其值为value，类似java中的replace 
127.0.0.1:6379> SETRANGE k1 2 XXX
(integer) 11
127.0.0.1:6379> get k1
"heXXX world"

4. SETEX key seconds value 设置key的值为value存活seconds秒后过期消失

5. SETNX key value  判断key是否存在，如果存在则忽略，否则设置key的值为value
127.0.0.1:6379> setnx k1 'aaa'
(integer) 0
127.0.0.1:6379> 

127.0.0.1:6379> setnx k5 'aaa'
(integer) 1
127.0.0.1:6379> 

6. MSET key value [key value ...]/MGET key [key ...] 设置/获取多个键值对
127.0.0.1:6379> mset k1 aaa k2 bbb k3 ccc
OK

127.0.0.1:6379> mget k1 k2 k3
1) "aaa"
2) "bbb"
3) "ccc"

7. MSETNX key value [key value ...]  设置多个键值对，如果其中一个key已经存在则本次操作全部忽略
 --k1已经存在,则忽略本次操作，即k1不会改变，k5为nil
127.0.0.1:6379> msetnx k1 xxx k5 yyy 
(integer) 0
 --查看k1 k5
127.0.0.1:6379> mget k1 k5 
1) "aaa"
2) (nil)
 --查看k1 到 k5 的值
127.0.0.1:6379> mget k1 k2 k3 k4 k5
1) "aaa"
2) "bbb"
3) "ccc"
4) (nil)
5) (nil)
 --msetnx 设置 k4 k5的值
127.0.0.1:6379> msetnx k4 xxx k5 yyy
(integer) 1
 --设置完 k4 k5后查看k1 到 k5 的值
127.0.0.1:6379> mget k1 k2 k3 k4 k5
1) "aaa"
2) "bbb"
3) "ccc"
4) "xxx"
5) "yyy"

8. GETSET key value  先get在set
127.0.0.1:6379> getset k6 ttt
(nil)

```

### 3.列表(List)





# Java使用Jedis连接Redis服务器

## 1.配置项

1. 需关闭Linux防火墙

``` shell
--1.查看防火墙状态
[root@MiWiFi-R1CL-srv ~]# firewall-cmd --state
running
--2.关闭防火墙
[root@MiWiFi-R1CL-srv bin]# systemctl stop firewalld.service
```

2. 修改 /myredis/redis.conf文件相关配置项

``` shell
1.redis默认只能通过本地localhost (127.0.0.1）进行连接，如果使用192.168.31.122连接则会报一下错误
(error) DENIED Redis is running in protected mode because protected mode is enabled, no bind address was specified, no authentication password is requested to clients. In this mode connections are only accepted from the lookback interface. If you want to connect from external computers to Redis you may adopt one of the following solutions: 1) Just disable protected mode sending the command 'CONFIG SET protected-mode no' from the loopback interface by connecting to Redis from the same host the server is running, however MAKE SURE Redis is not publicly accessible from internet if you do so. Use CONFIG REWRITE to make this change permanent. 2) Alternatively you can just disable the protected mode by editing the Redis configuration file, and setting the protected mode option to 'no', and then restarting the server. 3) If you started the server manually just for testing, restart it with the --portected-mode no option. 4) Setup a bind address or an authentication password. NOTE: You only need to do one of the above things in order for the server to start accepting connections from the outside.

解决方法:注释掉redis.conf文件中的 bind 127.0.0.1 即： #bind 127.0.0.1

2.Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程，使用jedis连接redis时需设置为出厂默认的no，即在redis.conf中找到daemonize，将其设置为: daemonize no  

3.设置保护模式，将出厂默认设置：protected-mode yes 设置为：protected-mode no   
```



## 2.java通过Jedis连接Redis服务器



1. 准备Jedis的jar包，使用maven下载Jedis的jar包

``` xml
<!-- https://mvnrepository.com/artifact/redis.clients/jedis -->
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>3.0.1</version>
</dependency>			
```

2. 编写测试类代码

``` java
public class RedisClientTest {
    @Test
    public void redisClient(){
        Jedis jedis = new Jedis("192.168.31.122",6379);
        System.out.println(jedis.ping());
        jedis.set("k1","hello world!");
        System.out.println(jedis.get("k1"));
    }
}
```