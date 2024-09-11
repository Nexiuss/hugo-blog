---
title: 'Tomcat容器部署'
date: 2024-09-11T18:12:56+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog"]
---

# Tomcat容器部署
以下是基于Tomcat 8的一个例子：
```Dockerfile
# 基础镜像为 Tomcat 8
FROM tomcat:8

# 环境变量设置
ENV CATALINA_BASE /usr/local/catalina
ENV CATALINA_HOME /usr/local/tomcat

# 复制 WAR 包到 webapps 目录
COPY front.war /usr/local/catalina/webapps/

# 修复 conf/Catalina/localhost 文件内容
RUN (cd /usr/local/catalina/conf && echo "front" > Catalina/localhost/front.xml)

# 指定 Tomcat 的工作目录为 CATALINA_BASE
WORKDIR /usr/local/catalina

# 指定环境变量指令
ENV PATH $CATALINA_HOME/bin:$PATH

#CMD ["catalina-jvm", "-Xmx512m", "-Djava.awt.headless=true", "-Djava.security.egd=/dev/urandom", "start"]
CMD ["catalina-console"]
```

这里，我们从 Tomcat 8 镜像开始，并且设置了 `CATALINA_BASE` 和 `CATALINA_HOME` 环境变量。

然后，我们将 WAR 包复制到 webapps 目录，并且修复 conf/Catalina/localhost 文件内容。

最后，我们设置了工作目录为 CATALINA_BASE，设置环境变量指令，让 PATH 中包含 Tomcat 的 bin 目录。

如果你需要自定义启动命令，可以在这里替换 `CMD` 指令。
