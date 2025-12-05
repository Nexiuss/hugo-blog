---
title: 'PostgreSQL与Kingbase的差异对比'
date: 2025-12-05T15:36:35+08:00
description: "A blog post"
image: "/images/20251205153635.png"
type: "post"
tags: ["blog"]
---

# PostgreSQL 与 Kingbase 的差异对比

Kingbase 是基于开源数据库 PostgreSQL 开发的，大部分功能与 PostgreSQL 兼容。Kingbase 8 是基于 PostgreSQL 9.6 的。本文列举发现的 PostgreSQL 9.6 与 Kingbase 8 的差异对比。

## 1 JDBC
|  | postgresql 9.6 | kingbase 8 |
| --- | --- | --- |
| driver_class | org.postgresql.Driver | com.kingbase8.Driver |
| url | jdbc:postgresql://127.0.0.1:5432/postgres | jdbc:kingbase8://127.0.0.1:54321/kingbase |
| jdbc 的 jar | postgresql.jdbc-9.0.jar<br><dependency><br><groupId>org.postgresql</groupId><br><artifactId>postgresql.jdbc</artifactId><br><version>9.0</version><br></dependency> | kingbase8-8.2.0.jar<br><dependency><br><groupId>com.kingbase8</groupId><br><artifactId>kingbase8-jdbc</artifactId><br><version>8.2.0</version><br></dependency> |
| hibernate 的 jar | hibernate-5.0.12.jar<br><dependency><br><groupId>org.hibernate</groupId><br><artifactId>hibernate</artifactId><br><version>5.0.12</version><br></dependency> | hibernate-3.6.0-dialect-1.0.jar<br><dependency><br><groupId>com.kingbase</groupId><br><artifactId>hibernate-3.6.0-dialect</artifactId><br><version>1.0</version><br></dependency> |
| hibernate 方言 | org.hibernate.dialect.PostgreSQL9Dialect | org.hibernate.dialect.Kingbase8Dialect |

这里 127.0.0.1 表示本地的 ip 地址。
5432 是 postgresql 的默认端口；54321 则是达梦的默认端口。
postgres 是 postgresql 默认的数据库名，kingbase 是 Kingbase 默认的数据库名。
这些参数可根据实际调整。

## 2 命令程序
| postgresql 9.6 | kingbase 8 |
| --- | --- |
| pgbench | kbbench |
| postgres | kingbase |
| psql | ksql |
| pg_archivecleanup | sys_archivecleanup |
| pg_basebackup | sys_basebackup |
| pg_bulkload | sys_bulkload |
| pg_config | sys_config |
| pg_controldata | sys_controldata |
| pg_ctl | sys_ctl |
| pg_dump | sys_dump |
| pg_dumpall | sys_dumpall |
| pg_hm | sys_hm |
| pg_isready | sys_isready |
| pglogical_create_subscriber | syslogical_create_subscriber |
| pg_receivexlog | sys_receivexlog |
| pg_recvlogical | sys_recvlogical |
| pg_resetxlog | sys_resetxlog |
| pg_restore | sys_restore |
| pg_rewind | sys_rewind |
| pg_rman | sys_rman |
| pg_test_fsync | sys_test_fsync |
| pg_test_timing | sys_test_timing |
| pg_upgrade | sys_upgrade |
| pg_xlogdump | sys_xlogdump |

可以看到，这里 kingbase 只是将 postgresql 的表的前缀从 pg 改成了 sys 或者 kb。

## 3 系统表和视图
| postgresql 9.6 | kingbase 8 |
| --- | --- |
| pg_aggregate | sys_aggregate |
| pg_am | sys_am |
| pg_amop | sys_amop |
| pg_amproc | sys_amproc |
| pg_attrdef | sys_attrdef |
| pg_attribute | sys_attribute |
| pg_authid | sys_authid |
| pg_auth_members | sys_auth_members |
| pg_cast | sys_cast |
| pg_class | sys_class |
| pg_collation | sys_collation |
| pg_constraint | sys_constraint |
| pg_conversion | sys_conversion |
| pg_database | sys_database |
| pg_db_role_setting | sys_db_role_setting |
| pg_default_acl | sys_default_acl |
| pg_depend | sys_depend |
| pg_description | sys_description |
| pg_enum | sys_enum |
| pg_event_trigger | sys_event_trigger |
| pg_extension | sys_extension |
| pg_foreign_data_wrapper | sys_foreign_data_wrapper |
| pg_foreign_server | sys_foreign_server |
| pg_foreign_table | sys_foreign_table |
| pg_index | sys_index |
| pg_inherits | sys_inherits |
| pg_init_privs | sys_init_privs |
| pg_language | sys_language |
| pg_largeobject | sys_largeobject |
| pg_largeobject_metadata | sys_largeobject_metadata |
| pg_namespace | sys_namespace |
| pg_opclass | sys_opclass |
| pg_operator | sys_operator |
| pg_opfamily | sys_opfamily |
| pg_partitioned_table | sys_partitioned_table |
| pg_pltemplate | sys_pltemplate |
| pg_policy | sys_policy |
| pg_proc | sys_proc |
| pg_publication | sys_publication |
| pg_publication_rel | sys_publication_rel |
| pg_range | sys_range |
| pg_replication_origin | sys_replication_origin |
| pg_rewrite | sys_rewrite |
| pg_seclabel | sys_seclabel |
| pg_sequence | sys_sequence |
| pg_shdepend | sys_shdepend |
| pg_shdescription | sys_shdescription |
| pg_shseclabel | sys_shseclabel |
| pg_statistic | sys_statistic |
| pg_statistic_ext | sys_statistic_ext |
| pg_subscription | sys_subscription |
| pg_subscription_rel | sys_subscription_rel |
| pg_tablespace | sys_tablespace |
| pg_transform | sys_transform |
| pg_trigger | sys_trigger |
| pg_ts_config | sys_ts_config |
| pg_ts_config_map | sys_ts_config_map |
| pg_ts_dict | sys_ts_dict |
| pg_ts_parser | sys_ts_parser |
| pg_ts_template | sys_ts_template |
| pg_type | sys_type |
| pg_user_mapping | sys_user_mapping |
| System Views | sysstem Views |
| pg_available_extensions | sys_available_extensions |
| pg_available_extension_versions | sys_available_extension_versions |
| pg_config | sys_config |
| pg_cursors | sys_cursors |
| pg_file_settings | sys_file_settings |
| pg_group | sys_group |
| pg_hba_file_rules | sys_hba_file_rules |
| pg_indexes | sys_indexes |
| pg_locks | sys_locks |
| pg_matviews | sys_matviews |
| pg_policies | sys_policies |
| pg_prepared_statements | sys_prepared_statements |
| pg_prepared_xacts | sys_prepared_xacts |
| pg_publication_tables | sys_publication_tables |
| pg_replication_origin_status | sys_replication_origin_status |
| pg_replication_slots | sys_replication_slots |
| pg_roles | sys_roles |
| pg_rules | sys_rules |
| pg_seclabels | sys_seclabels |
| pg_sequences | sys_sequences |
| pg_settings | sys_settings |
| pg_shadow | sys_shadow |
| pg_stats | sys_stats |
| pg_tables | sys_tables |
| pg_timezone_abbrevs | sys_timezone_abbrevs |
| pg_timezone_names | sys_timezone_names |
| pg_user | sys_user |
| pg_user_mappings | sys_user_mappings |
| pg_views | sys_views |

可以看到，这里 kingbase 只是将 postgresql 的表的前缀从 pg 改成了 sys。

## 4 创建函数的语法
| 差异项/数据库 | postgresql 9.6 | kingbase 8 |
| --- | --- | --- |
| 函数定义 | create or replace function f(a int)<br>returns int as<br>$$<br>begin<br>return 0;<br>end;<br>$$ language plpgsql; | create or replace internal function f(a int)<br>returns int as<br>$$<br>begin<br>return 0;<br>end;<br>$$ language plsql ; |
| 函数中声明变量 | create or replace function f(a int)<br>returns int as<br>declare a int;<br>declare b varchar(32);<br>$$<br>begin<br>return 0;<br>end;<br>$$ language plpgsql; | create or replace internal function f(a int)<br>returns int as<br>$$<br>declare<br>a int;<br>b varchar(32);<br>begin<br>return 0;<br>end;<br>$$ language plsql; |

## 5 其他要注意的事项
如果需要程序保持对 postgresql 的兼容性，需要在 kingbase 的配置文件 kingbase.conf 中修改或新增下面几个参数：
```
char_default_type = 'char'
ora_func_style = false
ora_numop_style = false
ora_input_emptystr_isnull = false
ora_plsql_style = false
ora_date_style = 'off'
ora_format_style = 'off'
```

下面是这几个参数的含义。

| 参数 | 含义 |
| --- | --- |
| char_default_type | VARCHAR 类型的长度单位。char 表示以字符位单位，byte 表示以字节为单位。 |
| ora_func_style | 设置兼容 Oracle 函数行为，默认为 true 启用状态。当设置 true 时，sequence.nextval 兼容 Oracle 的 Sequence 伪列行为。比如,SELECT SEQ.NEXTVAL AS A, SEQ.NEXTVAL AS B FROM DUAL，结果 A B 值相同。ltrim/rtrim/btrim 兼容 Oracle 对应函数行为，最长的只包含 characters 只能是一个字符。textcat 兼容 Oracle 字符串连接 NULL 时候，结果为字符串本身。regexp_replace 兼容 Oracle 该函数行为，regexp_replace 参数中有 NULL 出现，当做空串处理。当关闭（false）ora_func_style 时，上述函数表现为原有形式。 |
| ora_numop_style | 是否兼容 oracle 数学运算符的用法。默认为 true。 |
| ora_input_emptystr_isnull | 设置空串输入的输入形式（空串或 NULL）及部分函数返回值空串输出形式（空串或 NULL），默认为 true 启用状态。当启用（true）ora_input_emptystr_isnull 时，若输入空串，则空串将变成 NULL 的形式输入。 |
| ora_plsql_style | 是否是 oracle 的 plsql 风格。默认是 true。 |
| ora_date_style | 是否是 oracle 的日期风格。默认是 true。 |
| ora_format_style | 是否是 oracle 的格式风格。默认是 true。 |
