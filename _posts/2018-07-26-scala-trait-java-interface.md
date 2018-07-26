---
layout: post
title: Compare Scala trait to java interface
date: 2018-07-26 23:31:12 +0900
type: post
published: true
comments: true
categories: [Programming, Scala]
tags: [Java, Scala]
---

## Scala trait과 Java interface 비교
Java의 interface와 scala trait 둘 다 Class가 가지고 있는 특성을 추상화를 함.
그래서, 그에 대한 실제적 구현물은 interface 나 trait을 받는 쪽(`implements`, `with`)으로 맡길 수 있음. 
하지만, (1.8 버전 미만의) Java interface 는 추상 메소드만 선언 가능하고,
Scala trait 같은 경우는 trait 내에 추상 메소드 뿐만 아니라 실제 구현도 가능하다는 차이가 존재.

```scala
trait Hello {
  def printHello() = {
    println("Hello")
  }
}

object HelloImpl1 extends Hello
HelloImpl1.printHello()
// 콘솔 결과
// Hello

object HelloImpl2 extends Hello {
  override def printHello(): Unit = {
    println("Hello22")
  }
}
HelloImpl2.printHello()
// 콘솔 결과
// Hello22

object HelloImpl3 extends Hello {
  override def printHello(): Unit = {
    // 공통적으로 수행해야하는 내용이 trait 내에 존재
    super.printHello()
    // 구현체마다 다르게 실행되야하는 부분
    println("Hello22")
  }
}
HelloImpl3.printHello()
// 콘솔 결과
// Hello
// Hello22
```

`trait`에서 실제 구현도 가능하다는 점은 아래와 같은 점에서 편리함
- `HelloImpl1` 구현체와 같이 별다른 구현이 필요 없을 경우 `override` 없이 기본으로 실행 가능 (`HelloImpl2`와 같이 다른 구현이 필요한 경우도 처리 가능) 
- `HelloImpl3` 구현체와 같이 구현체들이 *공통적으로 수행해야하는 내용*이 있을 경우, `super`를 통하여 공통 수행 부분을 호출 가능

Java는 interface에서 메소드 구현이 완전 불가능한건지 좀 더 찾아보니 java 1.8 버전부터는 `default` 라는 키워드로 interface 내에서도 메소드의 구현이 가능.
- 참고글: [인터페이스에서 메소드 구현이 가능하다](http://dynaticy.tistory.com/entry/%EC%9D%B8%ED%84%B0%ED%8E%98%EC%9D%B4%EC%8A%A4%EC%97%90%EC%84%9C-%EB%A9%94%EC%86%8C%EB%93%9C-%EA%B5%AC%ED%98%84%EC%9D%B4-%EA%B0%80%EB%8A%A5%ED%95%98%EB%8B%A4)