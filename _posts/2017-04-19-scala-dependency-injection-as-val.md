---
layout: post
title: Dependency injection as val in scala
date: 2017-04-19 09:24:00 +0900
type: post
published: true
comments: true
categories: [scala]
tags: [scala, programming, dependency injection]
---

## Issue
스칼라에서의 Dependency Injection에서 어떤 경우에는 객체를 `val` 로 선언하고, 어떤 경우에는 그냥 하는지 궁금했음.
 
```scala
class TestDI @Inject() (val test: Test, test2: Test2) {

}
```

## Solution

> var 나 val 키워드는 어떤 참조가 다른 객체를 참조하도록 변경될 수 있는지(var), 또는 없는지(val) 여부만 지정한다. 
> 참조가 가리키는 대상 객체의 내부 상태를 변경 가능한지 여부는 지정하지 않는다.
Programming Scala p.86

위 내용을 참고하였을 때, Dependency Injection 되는 객체를 불변하게 한다는것을 명확하게 나타낼때 `val`를 사용하는 것으로 추정됨.
또한, 예는 Dependency Injection일 경우이지만 정확히는 class 생성 시 필요한 생성자 필드들의 선언 방법임. 

- [다음 글](https://alvinalexander.com/scala/how-to-control-visibility-constructor-fields-scala-val-var-private)을 참고하여 더 자세한 설명을 남김. 
(Updated at 2017.10.15) 
 
> the visibility of constructor fields in a Scala class is controlled by whether the fields are declared as val, var, without either val or var, and whether private is also added to the fields.

`val`, `var` 가 있거나 없거나 또는 그 앞에 `private`의 존재 유무들로 scala class에서 생성자 필드들의 접근(Accessor)과 수정(Mutator) 상태를 조정함.


