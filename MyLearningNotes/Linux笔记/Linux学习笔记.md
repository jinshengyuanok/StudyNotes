# Linux学习笔记

## CentOS 7

### 基础命令

#### 0. 系统更新命令

```shell
yum -y update
```

1. CentOS7从命令行窗口升级到图形界面

```shell
#我使用的163的yum源
yum repolist
#查看yum源是否正常正常的话直接yum安装
yum -y groupinstall "GNOME Desktop" "Graphical Administration Tools"
#需要安装一千多个包 需要大概二十分钟
#创建连接修改默认启动级别
ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
#安装完重启
reboot 
成功进入桌面系统
```



#### 1. 查看防火墙命令：

1. 查看防火墙状态:

``` shell
[root@localhost bin]# firewall-cmd --state
running
```

2. 关闭与开启防火墙命令：

``` shell
[root@localhost bin]# systemctl stop firewalld.service
[root@localhost bin]# systemctl start firewalld.service
```

#### 2. 文件目录操作命令

1. pwd:显示当前工作目录的绝对路径

2. ls [options ][目录或文件]

| 选项 | 说明                                       |
| ---- | ------------------------------------------ |
| - a  | 显示当前目录下所有文件和目录，包括隐藏目录 |
| -l   | 一列表形式显示信息                         |
|      |                                            |

3. cd [参数] ：切换到指定目录

   - 绝对路径:从更目录[/]下开始算起
   - 相对路径:从当前目录下开始定位到需要的目录

   `cd~` 或 `cd:`回到当前用户的家目录下

   `cd..` 回到当前目录上一级目录  

   #### 

#### 3.系统升级及旧内核清理

1. 查看版本及升级

```shell
1.查看内核版本
[root@localhost ~]# uname -sr
Linux 3.10.0-957.5.1.el7.x86_64

2.查看CentOS版本
[root@localhost ~]# cat /etc/redhat-release 
CentOS Linux release 7.6.1810 (Core) 

3.升级
[root@localhost ~]# yum clean all
已加载插件：fastestmirror
正在清理软件源： base extras updates

[root@localhost ~]# yum update
```

2. 查看系统中所有已安装过的内核rpm包

```shell
1.查看系统当前内核
[root@localhost ~]# uname -sr
Linux 3.10.0-957.5.1.el7.x86_64

2.只查看内核
[root@localhost ~]# rpm -q kernel
kernel-3.10.0-862.el7.x86_64
kernel-3.10.0-862.14.4.el7.x86_64
kernel-3.10.0-957.1.3.el7.x86_64
kernel-3.10.0-957.5.1.el7.x86_64

3.查看所有内核
[root@localhost ~]# rpm -qa | grep kernel
kernel-3.10.0-862.14.4.el7.x86_64
kernel-tools-libs-3.10.0-957.5.1.el7.x86_64
kernel-headers-3.10.0-957.5.1.el7.x86_64
kernel-tools-3.10.0-957.5.1.el7.x86_64
kernel-3.10.0-862.el7.x86_64
kernel-3.10.0-957.1.3.el7.x86_64
kernel-3.10.0-957.5.1.el7.x86_64
[root@localhost ~]# 
```

3. 删除旧的内核，删除后开机时不会出现多余选项

```shell
yum  remove 内核名称

[root@localhost ~]# yum remove kernel-3.10.0-862.el7.x86_64
已加载插件：fastestmirror
正在解决依赖关系
--> 正在检查事务
---> 软件包 kernel.x86_64.0.3.10.0-862.el7 将被 删除
--> 解决依赖关系完成

依赖关系解决
.......
```

4. 重启

```shell
reboot
```



#### 4. 升级到最新内核的方法

内核官网：https://www.kernel.org/

 ELRepo：http://elrepo.org/tiki/tiki-index.php

**参考：**

<https://blog.csdn.net/zofia_enjoy/article/details/78487832>

<https://blog.csdn.net/SweetTool/article/details/72759407>

<https://linux.cn/article-8310-1.html>

https://blog.phpgao.com/update_linux_kernel.html



大多数现代发行版提供了一种使用 [yum 等包管理系统](http://www.tecmint.com/20-linux-yum-yellowdog-updater-modified-commands-for-package-mangement/)和官方支持的仓库升级内核的方法。

但是，这只会升级内核到仓库中可用的最新版本 - 而不是在 <https://www.kernel.org/> 中可用的最新版本。不幸的是，Red Hat 只允许使用前者升级内核。

与 Red Hat 不同，CentOS 允许使用 ELRepo，这是一个第三方仓库，可以将内核升级到最新版本。

1.查看系统当前内核

```shell
[root@localhost ~]# uname -sr
Linux 3.10.0-957.5.1.el7.x86_64
```

2. 在 CentOS 7 上启用 ELRepo 仓库，运行：

```shell
[root@localhost ~]# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
[root@localhost ~]# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm^C
[root@localhost ~]#  www.elrepo.org
-bash: www.elrepo.org: 未找到命令
[root@localhost ~]# rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
获取http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
获取http://elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
准备中...                          ################################# [100%]
正在升级/安装...
   1:elrepo-release-7.0-3.el7.elrepo  ################################# [100%]
```

3. 仓库启用后，你可以使用下面的命令列出可用的内核相关包：

```shell
[root@localhost ~]# yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
已加载插件：fastestmirror
Loading mirror speeds from cached hostfile
 * elrepo-kernel: mirrors.neusoft.edu.cn
elrepo-kernel                                                                                                        | 2.9 kB  00:00:00     
elrepo-kernel/primary_db                                                                                             | 1.8 MB  00:00:00     
可安装的软件包
kernel-lt.x86_64                                                      4.4.174-1.el7.elrepo                                     elrepo-kernel
kernel-lt-devel.x86_64                                                4.4.174-1.el7.elrepo                                     elrepo-kernel
kernel-lt-doc.noarch                                                  4.4.174-1.el7.elrepo                                     elrepo-kernel
kernel-lt-headers.x86_64                                              4.4.174-1.el7.elrepo                                     elrepo-kernel
kernel-lt-tools.x86_64                                                4.4.174-1.el7.elrepo                                     elrepo-kernel
kernel-lt-tools-libs.x86_64                                           4.4.174-1.el7.elrepo                                     elrepo-kernel
kernel-lt-tools-libs-devel.x86_64                                     4.4.174-1.el7.elrepo                                     elrepo-kernel
kernel-ml.x86_64                                                      4.20.8-1.el7.elrepo                                      elrepo-kernel
kernel-ml-devel.x86_64                                                4.20.8-1.el7.elrepo                                      elrepo-kernel
kernel-ml-doc.noarch                                                  4.20.8-1.el7.elrepo                                      elrepo-kernel
kernel-ml-headers.x86_64                                              4.20.8-1.el7.elrepo                                      elrepo-kernel
kernel-ml-tools.x86_64                                                4.20.8-1.el7.elrepo                                      elrepo-kernel
kernel-ml-tools-libs.x86_64                                           4.20.8-1.el7.elrepo                                      elrepo-kernel
kernel-ml-tools-libs-devel.x86_64                                     4.20.8-1.el7.elrepo                                      elrepo-kernel
perf.x86_64                                                           4.20.8-1.el7.elrepo                                      elrepo-kernel
python-perf.x86_64                                                    4.20.8-1.el7.elrepo                                      elrepo-kernel
[root@localhost ~]# yum --enablerepo=elrepo-kernel install kernel-ml
```

4. 安装最新的主线稳定内核：

```shell
[root@localhost ~]# yum --enablerepo=elrepo-kernel install kernel-ml
已加载插件：fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.nwsuaf.edu.cn
 * elrepo: mirrors.neusoft.edu.cn
 * elrepo-kernel: mirrors.neusoft.edu.cn
 * extras: centos.cs.nctu.edu.tw
 * updates: centos.ustc.edu.cn
elrepo                                                                                                               | 2.9 kB  00:00:00     
elrepo/primary_db                                                                                                    | 221 kB  00:00:00     
正在解决依赖关系
--> 正在检查事务
---> 软件包 kernel-ml.x86_64.0.4.20.8-1.el7.elrepo 将被 安装
--> 解决依赖关系完成

依赖关系解决

============================================================================================================================================
 Package                       架构                       版本                                      源                                 大小
============================================================================================================================================
正在安装:
 kernel-ml                     x86_64                     4.20.8-1.el7.elrepo                       elrepo-kernel                      46 M

事务概要
============================================================================================================================================
安装  1 软件包

总下载量：46 M
安装大小：206 M
Is this ok [y/d/N]: y
Downloading packages:
kernel-ml-4.20.8-1.el7.elrepo.x86_64.rpm                                                                             |  46 MB  00:00:05     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
警告：RPM 数据库已被非 yum 程序修改。
  正在安装    : kernel-ml-4.20.8-1.el7.elrepo.x86_64                                                                                    1/1 
  验证中      : kernel-ml-4.20.8-1.el7.elrepo.x86_64                                                                                    1/1 

已安装:
  kernel-ml.x86_64 0:4.20.8-1.el7.elrepo                                                                                                    

完毕！
[root@localhost ~]# 
```

5. 重启系统

```shell
reboot 或 shutdown -r now
```

6. 设置GRUB默认的内核版本

- 为了让新安装的内核成为默认启动选项，你需要如下修改 GRUB 配置：
  打开并编辑 /etc/default/grub 并设置 GRUB_DEFAULT=0。意思是 GRUB 初始化页面的第一个内核将作为默认内核。

```shell
GRUB_TIMEOUT=5
GRUB_DEFAULT=0
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rd.lvm.lv=centos/swap crashkernel=auto rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
```

- 接下来运行下面的命令来重新创建内核配置。

```shell
grub2-mkconfig -o /boot/grub2/grub.cfg
```

- 重启并验证最新的内核已作为默认内核。

### 1.文件解压缩

`tar -zxvf [fileNmae] -C targetDir`

### 2.Jdk安装及环境变量配置

1. JDK：jdk-8u192-linux-x64.tar.gz
2. 解压：tar -zxvf  jdk-8u192-linux-x64.tar.gz -C /usr/local/java/
3. 环境变量配置

``` shell
1.当前用户环境变量配置(仅限当前登录用户使用)，编辑profile文件
使用命令 vim /etc/profile 打开profile文件后，在末尾添加下面内容：
export JAVA_HOME=/usr/local/java/jdk1.8.0_192
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

2.使/etc/profie文件生效
[root@localhost myDownloadFiles]# source /etc/profile

3.查看版本信息：
[root@localhost myDownloadFiles]# java -version
java version "1.8.0_192"
Java(TM) SE Runtime Environment (build 1.8.0_192-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.192-b12, mixed mode)
```

### 3. Tomcat安装

1. 需要先安装JDK
2. 官网下载：http://tomcat.apache.org/
3. 下载的版本为：apache-tomcat-8.5.37.tar.gz
4. 安装

``` shell
1.解压：
[root@localhost myDownloadFiles]# tar -zxvf apache-tomcat-8.5.37.tar.gz -C /usr/local

2.先进入apache-tomcat-8.5.37/bin/目录下启动
[root@localhost local]# cd apache-tomcat-8.5.37/bin/
[root@localhost bin]# ls -l
总用量 852
-rw-r-----. 1 root root  35051 12月 12 20:07 bootstrap.jar
-rw-r-----. 1 root root  15900 12月 12 20:07 catalina.bat
-rwxr-x---. 1 root root  24218 12月 12 20:07 catalina.sh
-rw-r-----. 1 root root   1664 12月 12 20:23 catalina-tasks.xml
-rw-r-----. 1 root root  25145 12月 12 20:07 commons-daemon.jar
-rw-r-----. 1 root root 207125 12月 12 20:07 commons-daemon-native.tar.gz
-rw-r-----. 1 root root   2040 12月 12 20:07 configtest.bat
-rwxr-x---. 1 root root   1922 12月 12 20:07 configtest.sh
-rwxr-x---. 1 root root   8508 12月 12 20:07 daemon.sh
-rw-r-----. 1 root root   2091 12月 12 20:07 digest.bat
-rwxr-x---. 1 root root   1965 12月 12 20:07 digest.sh
-rw-r-----. 1 root root   3460 12月 12 20:07 setclasspath.bat
-rwxr-x---. 1 root root   3680 12月 12 20:07 setclasspath.sh
-rw-r-----. 1 root root   2020 12月 12 20:07 shutdown.bat
-rwxr-x---. 1 root root   1902 12月 12 20:07 shutdown.sh
-rw-r-----. 1 root root   2022 12月 12 20:07 startup.bat
-rwxr-x---. 1 root root   1904 12月 12 20:07 startup.sh
-rw-r-----. 1 root root  49336 12月 12 20:07 tomcat-juli.jar
-rw-r-----. 1 root root 418183 12月 12 20:07 tomcat-native.tar.gz
-rw-r-----. 1 root root   4574 12月 12 20:07 tool-wrapper.bat
-rwxr-x---. 1 root root   5515 12月 12 20:07 tool-wrapper.sh
-rw-r-----. 1 root root   2026 12月 12 20:07 version.bat
-rwxr-x---. 1 root root   1908 12月 12 20:07 version.sh

3.启动Tomcat： 执行 ./startup.sh 进行启动
[root@localhost bin]# ./startup.sh 
Using CATALINA_BASE:   /usr/local/apache-tomcat-8.5.37
Using CATALINA_HOME:   /usr/local/apache-tomcat-8.5.37
Using CATALINA_TMPDIR: /usr/local/apache-tomcat-8.5.37/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_192/jre
Using CLASSPATH:       /usr/local/apache-tomcat-8.5.37/bin/bootstrap.jar:/usr/local/apa
che-tomcat-8.5.37/bin/tomcat-juli.jar
Tomcat started.

4.访问：打开浏览器输入 http://ip:8080/ 访问
【注意：如果无法访问，先查看下防火墙是否开启，如果开启先关闭下防火墙再访问】

5.关闭Tomcat服务，还是进入Tomcat安装目录下的bin目录，然后执行下面命令：
[root@localhost bin]# ./shutdown.sh 
Using CATALINA_BASE:   /usr/local/apache-tomcat-8.5.37
Using CATALINA_HOME:   /usr/local/apache-tomcat-8.5.37
Using CATALINA_TMPDIR: /usr/local/apache-tomcat-8.5.37/temp
Using JRE_HOME:        /usr/local/java/jdk1.8.0_192/jre
Using CLASSPATH:       /usr/local/apache-tomcat-8.5.37/bin/bootstrap.jar:/usr/local/apa
che-tomcat-8.5.37/bin/tomcat-juli.jar
```

5. 应用部署：跟Windows下部署一样，将打包好的war包上传到Linux系统的中Tomcat安装目录的webapp目录下，然后启动Tomcat即可



# Linux中遇到的相关问题及解决方法

## 1.使用SmarTTY登录Linux后，相关命令找不到问题

1. 在安装Linux的机器中输入 `ls -l`命令可以执行，但是远程工具登录后输入`ls -l`则提：示未找到命令

``` shell
[root@localhost ~]# ls -l
-bash: ls: 未找到命令
```

2. 问题原因：可能在执行某些命令时环境变量[PATH](https://www.baidu.com/s?wd=PATH&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)被修改了
3. 解决方法：

```shell
1. 输入下面命令，回车，立即生效【注：此方法只在本次会话中有些，关闭远程终端工具后就失效了】：
[root@localhost ~]# export PATH=/bin:/usr/bin:$PATH
3. 永久生效：编辑 ~/.bash_profile 文件
使用命令 vim ~/.bash_profile 打开文件，然后添加 export PATH=/bin:/usr/bin:$PATH 保存退出即可解决
```





