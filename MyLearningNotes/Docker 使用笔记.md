# docker使用笔记

## 一.CenteOS7中安装Docker

### 1.相关网站 

1. docker官网：https://www.docker.com/
2. docker官方文档：https://docs.docker.com/
3. docker中文社区：http://www.docker.org.cn/
4. docker hub: https://hub.docker.com
5. docker 菜鸟教程：http://www.runoob.com/docker/docker-tutorial.html
6. docker中国官方镜像加速：https://www.docker-cn.com/registry-mirror

### 2.CentOS7中安装docker

``` shell
1.安装要求，Linux的内核必须是3.10及以上版本，如果内核版本小于3.10 则使用 yum update 命令进行升级
uname -r 如：
[root@localhost ~]# uname -r
3.10.0-862.14.4.el7.x86_64
2.升级Linux软件包及其内核：
yum update

2.安装docker
yum install docker
3.查看docker的版本号  docker -v ，如：
[root@localhost ~]# docker -v
Docker version 1.13.1, build 07f3374/1.13.1
```

1. 启动、停止docker

``` shell
1.启动与停止
systemctl start docker
systemctl stop docker

2.如果将docker服务设置为开机启动，则使用下面命令
systemctl enable docker

[root@localhost ~]# systemctl enable docker
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.

```

### 3.卸载docker

``` shell
1.查询安装过的包: yum list installed | grep docker

[root@localhost ~]# yum list installed | grep docker
docker.x86_64                        2:1.13.1-88.git07f3374.el7.centos @extras  
docker-client.x86_64                 2:1.13.1-88.git07f3374.el7.centos @extras  
docker-common.x86_64                 2:1.13.1-88.git07f3374.el7.centos @extras 

2.删除安装的软件包
yum -y remove docker.x86_64\docker-client.x86_64\docker-common.x86_64

3.删除镜像/容器等
rm -rf /var/lib/docker
```







## 二.docker常用命令操作

### docker ps:列出容器

``` shell
1.镜像搜索(搜索出的列表其实就是docker hub 上的镜像列表)：
docker search mysql

2. docker ps [OPTIONS] 
OPTIONS说明：

-a :显示所有的容器，包括未运行的。

-f :根据条件过滤显示的内容。

--format :指定返回值的模板文件。

-l :显示最近创建的容器。

-n :列出最近创建的n个容器。

--no-trunc :不截断输出。

-q :静默模式，只显示容器编号。

-s :显示总的文件大小。

```

### 启动、停止、删除已经运行过的docker容器及镜像

``` shell
一、创建
docker create:创建容器，处于停止状态。
centos:latest:centos容器：最新版本(也可以指定具体的版本号)。
本地有就使用本地镜像，没有则从远程镜像库拉取。
创建成功后会返回一个容器的ID。
docker run:创建并启动容器。
交互型容器：运行在前台，容器中使用exit命令或者调用docker stop、docker kill命令，容器停止。
如下图已经在前台开启一个docker容器： 

二、查看
docker images 查看已安装的docker镜像
docker ps:  查看当前运行的容器
docker ps -a:查看所有容器，包括停止的。
查看后各标题含义：
CONTAINER ID:容器的唯一表示ID。
IMAGE:创建容器时使用的镜像。
COMMAND:容器最后运行的命令。
CREATED:创建容器的时间。
STATUS:容器状态。
PORTS:对外开放的端口。
NAMES:容器名。可以和容器ID一样唯一标识容器，同一台宿主机上不允许有同名容器存在，否则会冲突。

docker ps -l :查看最新创建的容器，只列出最后创建的。
docker ps -n=2:-n=x选项，会列出最后创建的x个容器。
三、启动
命令：docker start [NAME]/[CONTAINER ID]
容器名：docker start docker_run，或者ID：docker start CONTAINERID。
–restart(自动重启)：默认情况下容器是不重启的，–restart标志会检查容器的退出码来决定容器是否重启容器。 
docker run --restart=always --name docker_restart -d centos /bin/sh -c "while true;do echo hello world; sleep;done":
--restart=always:不管容器的返回码是什么，都会重启容器。
--restart=on-failure:5:当容器的返回值是非0时才会重启容器。5是可选的重启次数。 

四、终止
docker stop [NAME]/[CONTAINER ID]:将容器退出。
docker kill [NAME]/[CONTAINER ID]:强制停止一个容器。

五、删除容器
容器终止后，在需要的时候可以重新启动，确定不需要了，可以进行删除操作。
docker rm [NAME]/[CONTAINER ID]:不能够删除一个正在运行的容器，会报错。需要先停止容器。 

一次性删除：docker本身没有提供一次性删除操作，但是可以使用如下命令实现：
docker rm 'docker ps -a -q'：-a标志列出所有容器，-q标志只列出容器的ID，然后传递给rm命令，依次删除容器。

六、删除镜像：docker rmi [images id]
```

## Docker与宿主主机之间的文件拷贝

```shell
从主机复制到容器sudo docker cp host_path containerID:container_path

从容器复制到主机sudo docker cp containerID:container_path host_path
```



## 三.docker中安装各种软件docker镜像

### 1.docker中安装mysql及使用

1. 安装mysql

``` shell
docker images | greap mysql 查看是否已安装过mysql镜像
docker pull mysql  --安装mysql的last版本
docker pull mysql:5.7.24  --安装版本为5.7.24的mysql
```

2. 运行mysql

``` shell
docker run -d --name mysql7 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=yuan mysql:5.7.24
【注:这条命令的意思是：
    1.以后台方式运行mysql 5.7.24版本,且取名为mysql7；
    2.将主机(宿主)的3306端口映射到docker容器中的3306端口；
    3.初始root默默为yuan;
    *****此命令执行后直接注册到后台服务中，下次开机后只需要启动docker镜像即可，参见下文4*****
   】
```

3. Linux系统中进入docker容器内，修改mysqld.cnf配置文件

```shell
1. 进入容器
docker exec - it mysql7 /bin/bash
2.安装vim
apt-get update --更新
apt-get install vim --安装vim
3.编辑my.cnf文件
cd /etc/mysql切换到/etc/mysql目录下，然后vim my.cnf对my.cnf进行编辑
在my.cnf新增下面内容
[mysqld]
## 同一局域网内注意要唯一
server-id=2 
## 开启二进制日志功能，可以随便取（关键）
log-bin=mysql-bin
```

4. Linux系统中进入docker容器内，并登陆mysql

``` shell
1.进入容器
docker exec - it mysql7 bash
【注：mysql7为运行容器时的指定的mysql名称】
2.登陆mysql
mysql -u root -p 回车
输入root用户密码登录mysql
```

4. 查看mysql的引擎

``` sql
--查看mysql已提供的引擎
 show engines;
--查看mysql当前默认的存储引擎:
show variables like '%storage_engine%';
```



### 2.docker中安装Redis

#### Docker中国官方镜像加速

由于使用命令 docker pull redis 是从国外的网站中直接安装Redis速度较慢，而且很可能安装失败，所以下面使用docker中国镜像加速进行按照，网址及其使用说明如下：

https://www.docker-cn.com/registry-mirror

#### 安装Redis

Redis中文网：

http://www.redis.cn/

http://www.redis.net.cn/

命令：docker pull registry.docker-cn.com/library/redis

或下载指定的版本： docker pull registry.docker-cn.com/library/redis:xx.xx.xx

##### 1.运行Redis docker镜像

docker run -d -p 6379:6379 --name myredis  [REPOSITORY]/[IMAGE ID] 

如：docker run -d -p 6379:6379 --name myredis registry.docker-cn.com/library/redis

#### 连接Redis客户端实例

``` shell
1.在docker中连接Redis客户端命令：
docker exec -it [NAME]/[CONTAINER ID] redis-cli
这里以 NAME= redis5 为例,命令如下：
[root@localhost ~]# docker exec -it redis5 redis-cli
127.0.0.1:6379> 
```







## 四.CentOS中关闭与启动防火墙命令

``` shell
在外部访问CentOS中部署应用时，需要关闭防火墙。

关闭防火墙命令：systemctl stop firewalld.service

开启防火墙：systemctl start firewalld.service

关闭开机自启动：systemctl disable firewalld.service

开启开机启动：systemctl enable firewalld.service
```



[RedisDesktopManager 打开报0xc000007b程序错误](https://www.cnblogs.com/liuss2014/p/7102366.html)

 RedisDesktopManager 是一个管理redis的工具，很好用，我的电脑可以安装0.8.3版的，最新版到0.9.4了，其中经典版本是0.8.8，可惜0.8.3版之后，我的电脑安装软件后，打开都报报0xc000007b程序错误，从百度中查询解决的方法，但是都不行，后来综合搜索到的问题解决方案，自己想了很多办法弄好了。

第一步，需要软件depends22_x64(http://www.dependencywalker.com/)。这个软件的作用是查看当前打开的软件需要什么xx.dll，这样就可以有的放矢，在百度搜索原因。

第二步是安装对应xx.dll的软件，我这边是缺软件 VC++2005(vcredist_x86)，但是安装这个软件总是失败，![img](https://images2015.cnblogs.com/blog/541990/201707/541990-20170701144726743-1135462459.png)听从网友方法，使用DirectX_Repair_3.5加强版来扫描安装。

第三步 安装成功后，还是不行，此时要打补丁KB2999226，但是补丁卡住，一直显示“正在此计算机上搜索更新”，![img](https://images2015.cnblogs.com/blog/541990/201707/541990-20170701144707805-1725667230.png)

解决方法——

（1）.打开cmd，执行

net stop wuauserv（停止wuauserv服务）

（2）.打开windows目录，或者直接win+R 运行 %windir%打开目录 
（3）.找到一个文件夹SoftwareDistribution，删掉或者改名都行，这是更新程序使用的文件夹 
（4）.再次打开cmd，执行

net start  wuauserv（重新开启wuauserv服务）

这时再去安装KB2999226补丁，就不会卡住了。

最后软件就可以打开使用了。





