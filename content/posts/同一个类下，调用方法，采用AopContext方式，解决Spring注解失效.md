---
title: '同一个类下，调用方法，采用AopContext方式，解决Spring注解失效'
date: 2025-04-29T10:41:12+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog"]
---

# 同一个类下，调用方法，采用AopContext方式，解决Spring注解失效
## 背景
在Spring框架中，当一个类中的方法调用另一个方法时，如果被调用的方法使用了Spring注解（如@Transactional），则注解可能不会生效。这是因为Spring的AOP代理机制只对外部调用有效，内部调用不会触发AOP代理。

## 解决方法
使用AopContext来获取当前线程的AOP代理对象，然后通过该对象调用被注解的方法。这样可以确保注解生效。

示例：@Transaction 注解的方法，在方法内部调用的话，如果是直接调用，那么事务不会生效。需要通过AopContext获取代理对象，然后调用被注解的方法。
```java
@Transactional
public void transactionTask(String keyword) {
    doSth();
}
//反例
public void test() {
    transactionTask("test");
}
//正例
public void test2() {
    (当前类名)(AopContext.currentProxy()).transactionTask("test2");
}
```
## 配置要求
为了使 AopContext.currentProxy() 正常工作，需要在 Spring 的配置中启用 AOP 代理的暴露。这通常通过在配置类上添加 @EnableAspectJAutoProxy(exposeProxy = true) 注解来实现
```java
@Configuration
@EnableAspectJAutoProxy(exposeProxy = true)
public class SpringConfiguration {
// 其他配置代码
}
```
## 注意事项
虽然 AopContext.currentProxy() 提供了一种在同一个类中保持 AOP 增强有效的方法，但它并不是没有代价的。这种方法使用了 ThreadLocal 来存储代理对象，可能会对性能产生影响。因此，在使用时应当权衡利弊，并考虑是否有更好的设计方案，如将需要增强的方法放在不同的类中。

## 其他解决方案
1. 将被调用的方法放到另一个类中：这样，调用时会通过 Spring 的代理机制，保证 AOP 增强的执行。
2. 使用 Spring 上下文获取代理对象：可以通过 ApplicationContext.getBean() 方法获取需要的代理对象，然后进行方法调用。
