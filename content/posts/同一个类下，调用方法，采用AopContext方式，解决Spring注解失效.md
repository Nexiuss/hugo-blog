---
title: '同一个类下，调用方法，采用AopContext方式，解决Spring注解失效'
date: 2025-04-29T10:41:12+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog"]
---

# 同一个类下，调用方法，采用AopContext方式，解决Spring注解失效
背景：在Spring框架中，当一个类中的方法调用另一个方法时，如果被调用的方法使用了Spring注解（如@Transactional），则注解可能不会生效。这是因为Spring的AOP代理机制只对外部调用有效，内部调用不会触发AOP代理。

解决方法：使用AopContext来获取当前线程的AOP代理对象，然后通过该对象调用被注解的方法。这样可以确保注解生效。

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
