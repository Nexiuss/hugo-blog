---
title: 'Guave替代hutool'
date: 2026-01-29T14:41:02+08:00
description: "A blog post"
image: "/images/20260129144102.png"
type: "post"
tags: ["blog","java","guava","hutool"]
---

# Guave替代hutool
## 背景
Hutool已经被不够科技收购了，该公司前段时间因为其****在收购 AList 代码中悄悄收集用户设备信息****，而被推向过风口浪尖，业内人士认为其收购开源框架就是为了“投毒”，所以为此让收购框架损失了很多忠实的用户。为了规避风险，我们可以使用Guava来替代Hutool。

## 使用Guava替代Hutool
Guava是一个Java库，提供了许多实用的工具类和数据结构，可以替代Hutool中的许多功能。例如，Guava提供了ImmutableList、ImmutableMap等不可变集合，可以替代Hutool中的ImmutableList、ImmutableMap等不可变集合。此外，Guava还提供了许多实用的工具类，如Preconditions、Throwables等，可以替代Hutool中的Assert、ExceptionUtils等工具类。

## 示例代码
以下是一个使用Guava替代Hutool的示例代码：

```java
import com.google.common.base.Joiner;
import com.google.common.base.Optional;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.google.common.collect.Streams;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

class Scratch {
    public static void main(String[] args) throws ExecutionException {

        //## 字符串处理
        String str = null;
        // 判空（替代StrUtil.isEmpty），空安全，返回boolean
        boolean isEmpty = Strings.isNullOrEmpty(str);
        // 判空白（替代StrUtil.isBlank）
        boolean isBlank = Strings.isNullOrEmpty(Strings.emptyToNull(str));

        // 集合拼接（替代StrUtil.join），支持自定义分隔符，自动过滤null
        String join = Joiner.on(",").skipNulls().join("a", null, "b", "c"); // 结果：a,b,c

        // 字符串分割（替代StrUtil.split），支持去空白、忽略空值，返回不可变List
        Iterable<String> split = Splitter.on(",").trimResults().omitEmptyStrings().split("a, ,b,,c"); // 结果：[a,b,c]


        // ## 集合处理
        // 快速创建集合（替代CollUtil.newArrayList/newHashSet），无需泛型重复声明
        List<String> list = Lists.newArrayList("a", "b", "c");
        Set<Integer> set = Sets.newHashSet(1, 2, 3);
        Map<String, Integer> map = Maps.newHashMap();

        // 集合判空（替代CollUtil.isEmpty），空安全
        boolean collEmpty = Iterables.isEmpty(list);

        // 快速合并集合（替代CollUtil.addAll）
        List<String> list2 = Lists.newArrayList("d", "e");
        List<String> mergeList = Lists.newArrayList(Iterables.concat(list, list2)); // 结果：[a,b,c,d,e]

        // 创建不可变集合（线程安全，替代CollUtil.unmodifiableList）
        List<String> immutableList = ImmutableList.of("a", "b", "c");
        // 分组
        List<List<String>> groups = Lists.partition(list, 2);


        // ## 缓存处理
        // 创建缓存：最大容量100，写入后10分钟过期
        Cache<String, String> cache = CacheBuilder.newBuilder()
                .maximumSize(100)
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .build();

        // 存值/取值（替代CacheUtil的get/put）
        cache.put("key1", "value1");
        cache.get("key1", () -> "value1");

        // 移除缓存
        cache.invalidate("key1");

        // ## map 创建（缺点，一经创建，不能新增）
        // 方式1：ImmutableMap.of() - 适合少量键值对（最多支持5组k-v，超量用builder）
        Map<String, String> smallMap = ImmutableMap.of(
                "k1", "v1",
                "k2", "v2",
                "k3", "v3"
        );

        // 方式2：ImmutableMap.builder() - 适合任意数量键值对（最贴近MapBuilder链式风格）
        Map<Integer, String> bigMap = ImmutableMap.<Integer, String>builder()
                .put(1, "苹果")
                .put(2, "香蕉")
                .put(3, "橙子")
                .put(4, "葡萄")
                // 支持批量put（Guava特有的，MapBuilder无此能力）
                .putAll(ImmutableMap.of(5, "芒果", 6, "草莓"))
                .build();


        //Optional
        List<String> nullList = null; // 模拟null列表
        List<String> emptyList = Lists.newArrayList(); // 模拟空列表

        // 1. 空安全流：ofNullable() - 替代原生Stream.of()，处理null集合，避免NPE
        // 原生Stream.of(nullList)会抛NPE，Guava Streams.ofNullable()返回空流
        Stream<String> safeStream = Streams.stream(nullList);
        Stream<String> safeStream2 = Streams.stream(nullList);
        Streams.concat(safeStream, safeStream2);

        Optional<Object> objectOptional = Optional.fromJavaUtil(java.util.Optional.empty());
        objectOptional.asSet();

        System.out.println("null列表转空安全流的元素数：" + safeStream.count()); // 输出：0
    }
}
```
