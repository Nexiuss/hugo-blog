---
title: 'Docker启动'
date: 2024-09-12T13:07:27+08:00
description: "A blog post"
image: "/images/docker.png"
type: "post"
tags: ["blog","docker","k8s","oracle"]
---

# Docker启动

### engine配置

#### 初始配置
```
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  }
}
```

#### 配置
```
{
  "experimental": true,
  "debug": true,
  "registry-mirrors": ["http://hub-mirror.c.163.com"]
}
```

### reids
`docker run -it -d --name redis -p 6379:6379 redis --bind 0.0.0.0 --protected-mode no
`
### rabbitmq
* 创建卷
`docker volume create rabbitmq-home`
* 运行
`docker run -id --name=rabbitmq -v rabbitmq-home:/var/lib/rabbitmq -p 15672:15672 -p 5672:5672 -e RABBITMQ_DEFAULT_USER=swsk33 -e RABBITMQ_DEFAULT_PASS=123456 rabbitmq:management
`
### rocketmq
拉镜像
`docker pull rocketmqinc/rocketmq`

启动nameserver
```bash
docker run -d \
--privileged=true \
--name rmqnamesrv \
-v `pwd`/data/namesrv/logs:/root/logs  \
-v `pwd`/data/namesrv/store:/root/store \
apache/rocketmq sh mqnamesrv
```
启动broker
```bash
docker run -d -p 10911:10911 -p 10909:10909 -v `pwd`/data/broker/logs:/root/logs -v `pwd`/data/broker/store:/root/store --name rmqbrokerv2 --link rmqnamesrv:namesrv -e "NAMESRV_ADDR=namesrv:9876" dyrnq/rocketmq:4.8.0 sh mqbroker -c ../conf/broker.conf
```

### zookeeper
`docker run -d --name zookeeper -p 2181:2181 zookeeper
`
### nacos
#### docker-compose

* git clone
`https://github.com/nacos-group/nacos-docker.git
cd nacos-docker`
* 单机模式 Derby
`docker-compose -f example/standalone-derby.yaml up`

* 单机模式 MySQL
    1. 如果希望使用MySQL5.7
    `docker-compose -f example/standalone-mysql-5.7.yaml up`
    2. 如果希望使用MySQL8
    `docker-compose -f example/standalone-mysql-8.yaml up`
* 集群模式
`docker-compose -f example/cluster-hostname.yaml up `
* 服务注册
`curl -X POST 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
服务发现`
* 服务发现
`curl -X GET 'http://127.0.0.1:8848/nacos/v1/ns/instance/list?serviceName=nacos.naming.serviceName
`
* 发布配置
`curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=helloWorld
`
* 获取配置
`  curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test
`

[NACOS参考文档](https://nacos.io/zh-cn/docs/quick-start-docker.html)
#### docker run
* 启动命令
```bash
docker run \
--name nacos-server \
-p 8848:8848 \
-p 9848:9848 \
-p 9849:9849 \
-e MODE=standalone \
-e SPRING_DATASOURCE_PLATFORM=mysql \
-e MYSQL_SERVICE_HOST=host.docker.internal \
-e MYSQL_SERVICE_PORT=3306 \
-e MYSQL_SERVICE_USER=root \
-e MYSQL_SERVICE_PASSWORD=123456 \
-e MYSQL_SERVICE_DB_NAME=nacos \
-e TIME_ZONE='Asia/Shanghai' \
-d nacos/nacos-server:v2.2.3-slim
# 拷贝配置
docker cp -a nacos-server:/home/nacos /Users/nexius/Docker/nacos
# 关闭该容器
docker stop nacos-server
# 删除该容器
docker rm nacos-server
#再次运行
docker run \
--name nacos-server \
-p 8848:8848 \
-p 9848:9848 \
-p 9849:9849 \
-e MODE=standalone \
-e SPRING_DATASOURCE_PLATFORM=mysql \
-e MYSQL_SERVICE_HOST=host.docker.internal \
-e MYSQL_SERVICE_PORT=3306 \
-e MYSQL_SERVICE_USER=root \
-e MYSQL_SERVICE_PASSWORD=123456 \
-e MYSQL_SERVICE_DB_NAME=nacos \
-e TIME_ZONE='Asia/Shanghai' \
-v /Users/nexius/Docker/nacos/conf:/home/nacos/conf \
-v /Users/nexius/Docker/nacos/logs:/home/nacos/logs \
-v /Users/nexius/Docker/nacos/data:/home/nacos/data \
-d nacos/nacos-server:v2.2.3-slim
```

### oceanbase
```
# 根据当前容器部署最大规格的实例
docker run -p 2881:2881 --name obstandalone -d oceanbase/oceanbase-ce

# 部署 mini 的独立实例
docker run -p 2881:2881 --name obstandalone -e MINI_MODE=1 -d oceanbase/oceanbase-ce

```

### nginx
```
docker run -d -p 8080:80  \
              -p 8443:443  \
 --name nginxweb \
 --link answer-server:answerserver \
 -v /opt/docker/nginx/html:/usr/share/nginx/html \
 -v /opt/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
 -v /opt/docker/nginx/conf/conf.d:/etc/nginx/conf.d \
 -v /opt/docker/nginx/logs:/var/log/nginx \
 nginx
```

-d # 表示在一直在后台运行容器
-p 80:80 # 对端口进行映射，将本地8081端口映射到容器内部的80端口
--name # 设置创建的容器名称
-v # 将本地目录(文件)挂载到容器指定目录；
--link answer-server:answerserver 这计划是指需要转向本机docker容器的别名

[参考文档](https://zhuanlan.zhihu.com/p/114603487)

快速启动：
```
docker run -d -p 8080:80 -p 8443:443 \
-v /Users/nexius/Docker/nginx/html:/usr/share/nginx/html \
-v /Users/nexius/Docker/nginx/conf/conf.d:/etc/nginx/conf.d \
-v /Users/nexius/Docker/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /Users/nexius/Docker/docker/nginx/logs:/var/log/nginx \
--name nginx nginx
```
发现问题：
macos在docker中不支持docker host模式，只能通过host.docker.internal的方式访问宿主机

### 微服务
#### gateway
1. Dockerfile
```
FROM openjdk:8

ENV JAR_VERSION="1.0.13.0-SNAPSHOT" \
	TZ=Asia/Shanghai \
	APP_WORKDIR="/nexius/dev" \
	APP_NAME="gateway" \
	APP_PORT=8080 \
	JAVA_OPTS="-Xms256m -Xmx512m" \
	SKYWALKING_CONF="" \
	NACOS_DEFAULT=" -Dspring.cloud.nacos.server-addr=nacos:8848 -Dspring.cloud.nacos.config.shared-configs[0].data-id=PUBLIC-COMMON.properties -Dspring.cloud.nacos.config.shared-configs[0].refresh=false -Dspring.cloud.nacos.config.shared-configs[0].group=DEFAULT_GROUP -Dspring.cloud.nacos.config.namespace=insurance-upgrade -Dspring.cloud.nacos.config.group=DEFAULT_GROUP -Dremote-config.base.boot.config-center.type=2 -Dremote-config.base.boot.discovery.type=3 -Dapollo.bootstrap.enabled=false -Dspring.cloud.nacos.username=nacos -Dspring.cloud.nacos.password=nacos" \
	NACOS_CONF="" \
	OTHER_CONF=""

WORKDIR ${APP_WORKDIR}

ADD ${APP_NAME}-${JAR_VERSION}.jar  ./gateway/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE $APP_PORT

ENTRYPOINT java ${JAVA_OPTS} ${SKYWALKING_CONF} ${NACOS_DEFAULT} ${NACOS_CONF} ${OTHER_CONF} -jar ./gateway/${APP_NAME}-${JAR_VERSION}.jar
```
2. 启动命令
```
docker run -d -p 8666:8666 \
--name gateway \
-e NACOS_CONF="-Dspring.cloud.nacos.config.namespace=ats-dd -Dspring.cloud.nacos.server-addr=host.docker.internal:8848" gateway/v1
```

### oracle(苹果芯片)
```bash
docker run --name oracle -d -p 1521:1521 bladex/oracle:19c-arm
```
#### 授权
```bash
# 连接容器
docker exec -it oracle /bin/bash
# sysdba登录
sqlplus / as sysdba;
# 显示初始化的 pdbs
show pdbs;
# 修改system用户的密码
alter user system identified by system;
# 修改sys用户的密码
alter user sys identified by sys;
```
#### 创建用户
```bash
#使用ORCLPDB PDB访问
alter session set container = ORCLPDB;
#创建用户
create user yourusername identified by youruserpwd;
#授予权限
grant connect,resource,dba to yourusername;

```
#### 扩展 ：oracle实例 ORCLPDB和orclcdb的区别
oracle从12c开始增加了增加了CDB和PDB的概念，数据库引入的多租用户环境（Multitenant Environment）中，允许一个数据库容器（CDB）承载多个可插拔数据库（PDB）。CDB全称为Container Database，中文翻译为数据库容器，PDB全称为Pluggable Database，即可插拔数据库。在ORACLE 12C之前，实例与数据库是一对一或多对一关系（RAC）：即一个实例只能与一个数据库相关联，数据库可以被多个实例所加载。而实例与数据库不可能是一对多的关系。当进入ORACLE 12C后，实例与数据库可以是一对多的关系
* jdbc:oracle:thin:@//xxx:1521/ORCLPDB1：此URL连接到名为“ORCLPDB1.在Oracle多租户体系结构中，容器数据库（CDB）可以托管多个PDB。PDB充当CDB内的单独数据库。当您想要直接连接到特定PDB时，将使用此URL
* jdbc:oracle:thin:@//xxx:1521/ORCLCDB：此URL连接到容器数据库（CDB）本身，而不是特定的PDB。CDB是包含多个PDB的主数据库。当连接到CDB时，您可以访问和管理其中的所有PDB。此URL通常在需要执行管理任务或访问CDB级别的功能时使用。
选择使用哪个URL取决于应用程序的要求：
1. 如果您的应用程序需要与特定的PDB进行交互，例如执行SQL语句或在该PDB中执行数据访问操作，则应在连接中使用jdbc:oracle:thin:@//xxx:1521/ORCLPDB
2. 如果您的应用程序需要管理访问权限或需要在CDB级别执行任务，则可以使用jdbc:oracle:thin:@//xxx:1521/ORCLCDB

### DM8
达梦8
pull镜像
``` bash
docker pull qinchz/dm8-arm64
```
启动
``` bash
docker run -d -p 5236:5236 \
--name dm8 \
-v /Users/nexius/Docker/dm8/data:/home/dmdba/data \
qinchz/dm8-arm64
```
初始化数据库
``` sql
-- 查询表空间
select tablespace_name from dba_tablespaces;
-- 查询用户
select username from dba_users;
-- 创建表空间
CREATE TABLESPACE  TEST DATAFILE 'TEST.DBF' SIZE 300;
-- 创建用户
create user nexius identified by "123456789" default tablespace TEST default index tablespace TEST;
-- 授权
grant "RESOURCE","PUBLIC","DBA","VTI" to nexius;
```
#### DEM 达梦统一运维监控
[参考文档](https://blog.csdn.net/qinchaozengh/article/details/128038287)
docker-compose
``` yaml
version: '2.1'
services:
  tomcat:
    user: root
    restart: always
    container_name: tomcat
    image: tomcat:8.5.84-jre8
    privileged: true
    environment:
      - TZ="Asia/Shanghai"
    ports:
      - 8080:8080
    volumes:
      - /Users/chaz/dev/docker/data/dm8/tomcat/webapps:/Users/nexius/Docker/DEMwebapps
      #- /Users/chaz/dev/docker/data/dm8/tomcat/conf:/Users/nexius/Docker/DEMconf
      #- /Users/chaz/dev/docker/data/dm8/tomcat/logs:/Users/nexius/Docker/DEMlogs
      #- /Users/chaz/dev/docker/data/dm8/tomcat/bin:/Users/nexius/Docker/DEMbin
      #- /Users/chaz/dev/docker/data/dm8/bin:/opt/dmdbms/bin
      - /etc/localtime:/etc/localtime
```
### minio
```docker
docker run -p 9000:9000 -p 9090:9090 \
--name minio \
-d --restart=always \
-e "MINIO_ACCESS_KEY=mbti" \
-e "MINIO_SECRET_KEY=mbti@123" \
-v /Users/nexius/Docker/minio/data:/data \
minio/minio server \
/data --console-address ":9090" -address ":9000"
```
