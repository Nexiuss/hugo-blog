---
title: '解决国密org.bouncycastle依赖冲突'
date: 2025-01-23T09:29:10+08:00
description: "A blog post"
image: "/images/bouncycastle.png"
type: "post"
tags: ["blog","jdk15on","bcprov","国密"]
---

**解决BouncyCastle依赖冲突的两种方案**
=====================================

背景：本地项目使用的 BouncyCastle 1.61 版本，但第三方 SDK 要求使用 1.70 版本，导致 jar 包冲突的问题。

### 方案一：使用Shade插件实现隔离

#### pom文件配置插件
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>3.2.4</version>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>shade</goal>
            </goals>
            <configuration>
                <!-- 将org.bouncycastle包的类重定位到shaded.org.bouncycastle -->
                <relocations>
                    <relocation>
                        <pattern>org.bouncycastle</pattern>
                        <shadedPattern>shaded.org.bouncycastle</shadedPattern>
                    </relocation>
                </relocations>
                <!-- 排除一些元数据文件 -->
                <filters>
                    <filter>
                        <artifact>*:*</artifact>
                        <excludes>
                            <exclude>META-INF/*.SF</exclude>
                            <exclude>META-INF/*.DSA</exclude>
                            <exclude>META-INF/*.RSA</exclude>
                            <exclude>sdk.configure.properties</exclude>
                        </excludes>
                    </filter>
                </filters>
            </configuration>
        </execution>
    </executions>
</plugin>
```

#### 不希望打入项目的包可以scope配置为provided
#### 项目打包完成后，可以使用带有Shaded BouncyCastle的jar包

### 方案二：自己定义ClassLoad实现隔离

#### SdkClassLoader类
```java
public class SdkClassLoader extends URLClassLoader {

    private final ClassLoader parent;
    /* The search path for classes and resources */
    private final URLClassPath ucp;

    /* The context to be used when loading classes and resources */
    private final AccessControlContext acc;


    public SdkClassLoader(URL[] urls, ClassLoader parent) {
        super(urls, parent);
        this.parent = parent;
        this.acc = AccessController.getContext();
        ucp = new URLClassPath(urls, acc);
    }

    @Override
    protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        // 尝试使用系统类加载器父类加载类（JDK类）
        Class<?> c = getSystemClassLoader().getParent().loadClass(name);
        if (c == null) {
            // 如果未找到，则委托给父类加载器加载类
            c = parent.loadClass(name);
        }
        if (resolve) {
            resolveClass(c);
        }
        return c;
    }

    private static void printUrls(URL[] urLs) {
        for (int i = 0; i < urLs.length ; i ++){
            URL urL = urLs[i];
            System.out.println("urL = " + urL.toExternalForm());
        }
    }

    @Override
    protected Class<?> findClass(String name) throws ClassNotFoundException {
        // ...
    }
}
```

#### 调用代码
```java
URL[] urls = getLibUrls(System.getProperty("sdk-lib","path/to/lib"));
SdkClassLoader sdkClassLoader = new SdkClassLoader(urls, ISpdbSdk.class.getClassLoader());

Class<?> classes;
try {
    classes = Class.forName("com.djbx.spdb.sdk.SpdbSdkImpl", true, sdkClassLoader);
    spdbSdk=(ISpdbSdk) classes.newInstance();
} catch (ClassNotFoundException | InstantiationException | IllegalAccessException e) {
    throw new RuntimeException(e);
}
```

**注意事项**

* 接口类需要在系统默认 classLoader 加载，其他类，包括实现类等需要在自定义类加载器中加载。
* 需要保证系统类加载器可以加载接口类。
