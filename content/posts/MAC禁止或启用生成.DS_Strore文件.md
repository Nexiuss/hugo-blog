---
title: 'MAC禁止或启用生成.DS_Strore文件'
date: 2025-01-08T10:47:57+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog","MAC","摘抄"]
---

**删除和控制 macOS 上 Finder 创建的 .DS_Store 文件**
===========================================================

Finder 会为每个文件夹创建 `.DS_Store` 文件来存储显示属性，如文件图标位置、排列方式等。在分享或上传文件时，通常需要手动删除这些文件，以避免与他人共享的副本出现不同的显示配置问题。

**命令**
--------

### 1. 删除当前目录及其子目录下 .DS_Store 文件

```
sudo find ./ -name ".DS_Store" -depth -exec rm {} \;
```

### 2. 设置不再创建 .DS_Store 文件（永久生效后重启 mac 才能有效果）

```
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
```

### 3. 恢复默认行为

```
defaults delete com.apple.desktopservices DSDontWriteNetworkStores
```

**macOS 新版本中提供的脚本**
-----------------------------

macOS 新版本中提供了一个专门的脚本来处理这一问题。该脚本名为 `dot_clean`。

### 使用 dot_clean 脚本删除 .DS_Store 文件

```
/usr/sbin/dot_clean -m '目录名'
```

支持针对特定目录设置不再创建此类文件的规则。

**注意**
----

* 在使用这些命令之前，请确保已经进入要操作的目录。
* 请务必小心地执行这些命令，以免意外删除重要数据。
* 如果您使用 `dot_clean` 脚本，需要在 macOS Catalina 或更高版本下才能生效。
