---
title: 'Java启动jar包加载lib'
date: 2024-12-07T11:21:14+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog","java","jar"]
---

# Java启动jar包加载lib
## 示例
windows
```bash
@echo off
java -cp "lib/*;myapp.jar" com.example.MainClass
```
linux
```bash
#!/bin/bash
java -cp "lib/*:myapp.jar" com.example.MainClass
```
1. -cp参数的作用
在Java中，-cp（或--classpath）参数用于指定Java程序运行时需要查找类和包的路径。

2. 基本用法：
`java -cp <class_path> <main_class> [args...]`
* <class_path>：用冒号（在Unix/Linux/macOS上）或分号（在Windows上）分隔的类路径列表。
* <main_class>：包含main方法的Java类的全限定名（包括包名）。
* [args...]：传递给main方法的参数。

3. 如何指定多个类路径
```bash
# Unix/Linux/macOS
java -cp /path/to/lib1:/path/to/lib2:/path/to/classes MyApp
```
```bash
# Windows
java -cp C:\path\to\lib1;C:\path\to\lib2;C:\path\to\classes MyApp
```
4. 当类路径中包含空格时应如何处理
如果类路径中包含空格，你需要将整个路径用引号括起来，以确保空格被正确处理。例如：

```bash
# Unix/Linux/macOS
java -cp "/path/to/some directory with spaces/lib.jar:/other/path/classes" MyApp

# Windows
java -cp "C:\Program Files\Java\lib\mylib.jar;C:\other path\classes" MyApp
```
