---
title: 'Java_profile'
date: 2026-05-02T15:01:51+08:00
description: "A blog post"
image: "/images/20260502150151.png"
type: "post"
tags: ["blog","bash","shell","mac"]
---

# Java_profile

```bash
# ========== JDK 快速切换 alias ==========
# 查看所有已安装 JDK
alias jv="/usr/libexec/java_home -V"

# 临时切换当前终端 JDK
alias jdk8="export JAVA_HOME=\$(/usr/libexec/java_home -v 1.8) && java -version"
alias jdk11="export JAVA_HOME=\$(/usr/libexec/java_home -v 11) && java -version"
alias jdk17="export JAVA_HOME=\$(/usr/libexec/java_home -v 17) && java -version"
alias jdk21="export JAVA_HOME=\$(/usr/libexec/java_home -v 21) && java -version"
```
