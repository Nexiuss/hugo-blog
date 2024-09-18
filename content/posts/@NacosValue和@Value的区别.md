---
title: '@NacosValue和@Value的区别'
date: 2024-09-18T17:14:31+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog","spring","nacos"]
---

# @NacosValue 和@Value的区别
* 这两个注解都可以用于获取配置属性的值，但在使用方式和适用场景上有一些异同之处。

## 相同点：

* 两者都可以将配置属性的值注入到类的字段或方法参数中。
* 都支持 Spring 表达式语言（SpEL）来引用其他属性或进行运算。

## 不同点：
* 来源：@Value 注解是 Spring 框架提供的注解，可用于读取各种配置文件（如 properties、yml 等），而 @NacosValue 注解是 Alibaba Nacos 提供的注解，专门用于从 Nacos 配置中心获取属性值。
* 动态刷新：@Value 注解默认情况下不支持动态刷新，即配置变化后不会自动重新注入新值，而 @NacosValue 注解通过设置 autoRefreshed = true 可以实现配置动态刷新，当 Nacos 配置发生变化时，自动更新对应的属性值。
* 配置优先级：对于相同属性名的配置，@NacosValue 注解优先级高于 @Value 注解。也就是说，如果同时在 Nacos 和其他配置文件（如 bootstrap.properties、application.properties）中存在相同属性名的配置，那么 @NacosValue 注解获取的是 Nacos 中的属性值。

根据具体的需求，选择合适的注解来获取配置属性的值。如果你使用 Nacos 作为配置中心并希望实现动态刷新，可以选择 @NacosValue 注解；如果要读取其他类型的配置文件或不需要动态刷新，可以选择 @Value 注解。
