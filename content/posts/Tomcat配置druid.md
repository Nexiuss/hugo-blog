---
title: 'Tomcat配置druid'
date: 2024-11-13T13:26:17+08:00
description: "A blog post"
image: "/images/druid.png"
type: "post"
tags: ["blog","druid","tomcat"]
---

# Tomcat配置druid
## 流程概述
1. 在/home/tomcat/apache-tomcat-8.5.31/lib目录
  * 删除tomcat-dbcp.jar
  * 追加druid-1.1.9.jar
2. 改Tomcat web.xml配置
3. 改Tomcat context.xml配置
4. 检查项目中是否有权限拦截的，需要放开拦截，改项目的web.xml
5. 如果druid没加载上，再改catalina.properties
6. 验证地址： {ip}:{host}/{project_name}/druid/login.html

## 修改tomcat下的web.xml，里面增加druid配置
```xml
<!-- druid view -->
<servlet>
    <servlet-name>DruidStatView</servlet-name>
    <servlet-class>com.alibaba.druid.support.http.StatViewServlet</servlet-class>
    <init-param>
        <!-- 允许清空统计数据 -->
        <param-name>resetEnable</param-name>
        <param-value>true</param-value>
    </init-param>
    <init-param>
        <!-- 用户名 -->
        <param-name>loginUsername</param-name>
        <param-value>admin</param-value>
    </init-param>
    <init-param>
        <!-- 密码 -->
        <param-name>loginPassword</param-name>
        <param-value>admin</param-value>
    </init-param>
</servlet>

<servlet-mapping>
    <servlet-name>DruidStatView</servlet-name>
    <url-pattern>/druid/*</url-pattern>
</servlet-mapping>
<!-- druid view -->

<!-- 连接池 启用 Web 监控统计功能    start-->
	<filter>
		<filter-name>DruidWebStatFilter</filter-name>
		<filter-class>com.alibaba.druid.support.http.WebStatFilter</filter-class>
		<init-param>
			<param-name>exclusions</param-name>
			<param-value>*.js ,*.gif ,*.jpg ,*.png ,*.css ,*.ico ,*.map,/druid/*</param-value>
		</init-param>
		<init-param>
			<param-name>sessionStatMaxCount</param-name>
			<param-value>2000</param-value>
		</init-param>
		<init-param>
			<param-name>sessionStatEnable</param-name>
			<param-value>true</param-value>
		</init-param>
		<init-param>
			<param-name>principalSessionName</param-name>
			<param-value>session_user_key</param-value>
		</init-param>
		<init-param>
			<param-name>profileEnable</param-name>
			<param-value>true</param-value>
		</init-param>
	</filter>
	<filter-mapping>
		<filter-name>DruidWebStatFilter</filter-name>
		<url-pattern>/*</url-pattern>
	</filter-mapping>
	<!-- 连接池 启用 Web 监控统计功能   end-->
```
## context.xml配置
```xml
<Resource name="prpDataSource"
          auth="Container"
          type="javax.sql.DataSource"
          factory="com.alibaba.druid.pool.DruidDataSourceFactory"
          defaultTransactionIsolation="READ_COMMITTED"
          username="用户名"
          password="密码"
          filters="stat,wall"
          driverClassName="oracle.jdbc.OracleDriver"
          url="jdbc:oracle:thin:@ip:端口:service"
          maxActive="96"
          minIdle="8"
          removeabandoned="true"
          removeabandonedtimeout="60"
          logabandoned="true">
</Resource>
```

## 如果druid没加载上，再改catalina.properties
增加：druid-1.1.9.jar

## 页面访问
### 登陆界面
* {ip}:{host}/{project_name}/druid/login.html

用户名密码，请参考web.xml中的loginUsername属性
![登陆界面](/images/druid/login.png)

### 首页
* {ip}:{host}/{project_name}/druid/index.html
![首页](/images/druid/index.png)
