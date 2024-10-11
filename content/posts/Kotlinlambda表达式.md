---
title: 'Kotlin lambda表达式'
date: 2024-10-11T15:39:32+08:00
description: "A blog post"
image: "/path/to/image.png"
type: "post"
tags: ["blog"]
---

# Kotlin lambda表达式
## “Lambda 表达式语法”
Lambda 表达式的完整语法形式如下：
`val sum: (Int, Int) -> Int = { x: Int, y: Int -> x + y }`
* lambda 表达式总是括在花括号中。
* 完整语法形式的参数声明放在花括号内，并有可选的类型标注。
* 函数体跟在一个 -> 之后。
* 如果推断出的该 lambda 的返回类型不是 Unit，那么该 lambda 主体中的最后一个（或可能是单个）表达式会视为返回值。

如果将所有可选标注都留下，看起来如下：
`val sum = { x: Int, y: Int -> x + y }`

## “传递末尾的 lambda 表达式”
按照 Kotlin 惯例，如果函数的最后一个参数是函数，那么作为相应参数传入的 lambda
表达式可以放在圆括号之外：
```kt
// 完整代码
items.fold(0, {
        acc, e -> acc * e
    })
```
`val product = items.fold(1) { acc, e -> acc * e }`
这种语法也称为拖尾 lambda 表达式。
如果该 lambda 表达式是调用时唯一的参数，那么圆括号可以完全省略：
```kt
// 完整代码
run({()->println("...")})
```

`run { println("...") }`
## it：单个参数的隐式名称
```kt
// 完整代码
ints.filter { (it: Int) -> Boolean = it > 0 }
```

`ints.filter { it > 0 }`
