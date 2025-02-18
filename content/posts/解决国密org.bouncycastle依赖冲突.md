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
1. 首先建立一个工具工程引入需要shade jar 包
2. 配置 maven-shade插件，通过 pattern shadedPattern属性来配置要更改的包的名字
3. 使用shade 后的jar包，import 更改后的包名字，若有反射调用，也反射更改后的包名字

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
#### **补充**：此方案由于是修改了jar包的，若使用 oracle-jdk 启动应用，会导致出现以下错误：
```
Caused by: java.io.IOException: error constructing MAC: java.lang.SecurityException: JCE cannot authenticate the provider BC
```
主要原因为：OracleJDK验证了加密签名，而打包的过程破坏了验证BC库的签名
解决方式为：使用非 oracle jdk，如 open jdk

### 方案二：自己定义ClassLoad实现隔离
大概思路：自定义类加载器的父加载器为应用加载器（如tomcat为tomcat 的类加载器，weblogic为weblogic的类加载器），
自定义类加载器加载类的时候，如果在配置的 jar 列表内找了的类，则加载成功
没找到则委托给 parent 去加载，parent 一般加载顺序是 先加载 jdk的类，再加载 ext 的再加载 jre/lib 下的，最后加载应用 classpath 的

#### SdkClassLoader类
```java
public class SdkClassLoader extends URLClassLoader {

    private final ClassLoader parent;


    public SdkClassLoader(URL[] urls, ClassLoader parent) {
        super(urls, parent);
        this.parent = parent;
        System.out.printf("SdkClassLoader urls = %s%n", Arrays.toString(urls));
        if (parent instanceof URLClassLoader){
            System.out.printf("ParentClassLoader[%s] urls = %s%n", parent,Arrays.toString(((URLClassLoader) parent).getURLs()));
        }else {
            System.out.printf("ParentClassLoader[%s]", parent);
        }
    }
    @Override
    protected Class<?> loadClass(String name, boolean resolve) {
        synchronized (getClassLoadingLock(name)) {
            // 首先，检查类是否已经被加载
            Class<?> c = findLoadedClass(name);
            if (c == null) {
                try {
                    // 尝试在当前类加载器中查找类
                    c = findClass(name);
                } catch (ClassNotFoundException e) {
                    // doNothing
                }
                if(c == null){
                    // 如果未找到，则委托给父类加载器加载类
                    try {
                        if (parent != null) {
                            c = parent.loadClass(name);
                            System.out.println("parent:["+name+"]");
                        }
                    } catch (ClassNotFoundException e) {
                        System.out.printf("[%s] in parent is null %n",name);
                        throw new RuntimeException(e);
                    }
                }else {
                    System.out.printf("this:[%s]%n" , name);
                }
            }
            if (resolve) {
                resolveClass(c);
            }
            return c;
        }
    }
}
```

#### 调用代码
```java
URL[] urls = getLibUrls(System.getProperty("sdk-lib","path/to/lib"));
SdkClassLoader sdkClassLoader = new SdkClassLoader(urls, ISdk.class.getClassLoader());

Class<?> classes;
try {
    classes = Class.forName("xxx.xxx.iSdkImpl", true, sdkClassLoader);
    iSdk=(ISdk) classes.newInstance();
} catch (ClassNotFoundException | InstantiationException | IllegalAccessException e) {
    throw new RuntimeException(e);
}
```

**注意事项**

* 接口类需要在系统默认 classLoader加载（通过 classLoader 的 parent 传进来），否则会提示强转失败，其他类，包括实现类等需要在自定义类加载器中加载。
* 需要保证系统类加载器可以加载接口类。
