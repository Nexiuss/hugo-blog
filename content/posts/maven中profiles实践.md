---
title: 'Maven中profiles实践'
date: 2025-07-25T17:53:21+08:00
description: "A blog post"
image: "/images/20250725175321.png"
type: "post"
tags: ["blog"]
---

# Maven中profiles实践
pom.xml
```xml
    <profiles>
        <profile>
            <id>dev</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <env>dev</env>
            </properties>
        </profile>
        <profile>
            <id>test</id>
            <properties>
                <env>test</env>
            </properties>
        </profile>
        <profile>
            <id>pro</id>
            <properties>
                <env>pro</env>
            </properties>
        </profile>
    </profiles>

    <build>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
                <includes>
                    <include>application-${env}.properties</include>
                    <include>application.properties</include>
                </includes>
            </resource>
        </resources>
    </build>
```

resources
```
├── application-dev.properties
├── application-pro.properties
└── application.properties
```

application.properties
```properties
profiles.active=@env@
```

PropertiesLoader.java
```java
public class PropertiesLoader {

    public static void loadProperties() {
        try {
            System.getProperties().load(PropertiesLoader.class.getClassLoader().getResourceAsStream("application.properties"));
            String profileActive = System.getProperty("profiles.active");
            System.getProperties().load(PropertiesLoader.class.getClassLoader().getResourceAsStream("application-" + profileActive + ".properties"));
        } catch (IOException e) {
            throw new RuntimeException("加载配置文件失败！");
        }
    }
}
```
