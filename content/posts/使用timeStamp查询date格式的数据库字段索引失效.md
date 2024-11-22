---
title: '使用timeStamp查询date格式的数据库字段索引失效'
date: 2024-11-22T14:49:08+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog","Oracle","SQL"]
---

# 使用timeStamp查询date格式的数据库字段索引失效
## 背景
一次大表查询的过程中，为防止数据量太大，使用了timestamp作为查询条件来过滤一个数据库类型为date的字段,如下图所示：
`select * from t_xxx t where t.transdate>=timestamp '2024-11-22 00:00:00' and t.transdate<=timestamp '2024-11-22 59:59:59'`
此处transdate在数据库数据类型为date类型
发现搜索时间比较长，通过explain plan 发现是transdate过滤的时候，走了全表查询
```table
------------------------------------------------------------------------------------------------
| Id  | Operation                | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------
|*  5 |      TABLE ACCESS FULL   | S3_ACCOUNTSTATEMENT |    42 |  2562 |  1060   (1)| 00:00:01 |
------------------------------------------------------------------------------------------------
```
## 原因
通过分析发现当使用
`select * from t_xxx t where t.transdate>=to_date(yyyy-MM-dd HH:mm:ss,'2024-11-22 00:00:00')and t.transdate<=to_date(yyyy-MM-dd HH:mm:ss,'2024-11-22 59:59:59')`
性能明显提升，命中的索引，通过分析得知：transdate字段类型是Date，不支持对 timestamp值进行精确匹配，故索引失效

## 解决方式
将字段转换为date，再去查询数据库
