---
title: 'Oracle中utf 8中文占用'
date: 2025-06-10T18:39:39+08:00
description: "A blog post"
image: "/images/20250610183939.png"
type: "post"
tags: ["blog"]
---

# Oracle中utf 8中文占用

## 储存原理
UTF-8 是一种可变长 Unicode 编码：
* 基本 ASCII 字符（如英文字母、数字）占用 1 个字节。
* 绝大多数常用汉字及其他 Unicode 扩展字符（涵盖中日韩等文字）占用 3 个字节
## 字段长度限制的影响
Oracle 中 VARCHAR2(N) 默认定义的是字节长度（BYTE 语义）：
* VARCHAR2(10) 表示最多存储 10 个字节。
* 在 UTF-8 数据库中，最多可存储 3 个中文字符（3 字符 * 3 字节/字符 = 9 字节），剩余 1 字节不足以存储第 4 个汉字
* 若需按字符数定义长度，需显式指定 CHAR 语义：VARCHAR2(10 CHAR）
此时表示最多存储 10 个字符，不论字符类型：
* 可存 10 个汉字（共占用 30 字节）
* 或 10 个英文字母（共占用 10 字节）
## 验证方法
查询数据库字符集：
```sql
SELECT USERENV('LANGUAGE') FROM dual; -- 结果应包含 AL32UTF8 或 UTF8
SELECT value FROM NLS_DATABASE_PARAMETERS WHERE parameter = 'NLS_CHARACTERSET'; -- 结果应为 AL32UTF8 或 UTF8
```
查询单个汉字字节长度：
```sql
SELECT LENGTHB('汉') FROM dual; -- 在 UTF-8 数据库中应返回 3
```
总结与提示：
* UTF-8 编码下，Oracle 中每个汉字占用 3 字节存储空间‌。
* 设计表结构时，务必注意 VARCHAR2(N) 默认按字节计数‌。若字段需存储中文为主的内容，强烈建议使用 CHAR 语义（VARCHAR2(N CHAR)）定义长度，避免因字节计算导致存储空间不足
* 使用 LENGTHB() 函数可验证特定字符串的实际字节长度
