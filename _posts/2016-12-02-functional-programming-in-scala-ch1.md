---
layout: post
title: Functional Programming in scala #1
date: 2016-12-02 20:40:36 +0900
type: post
published: true
comments: true
categories: [Scala]
tags: [Scala, Functional programming]
type: book
---

## 함수형 프로그래밍이란 무엇인가?
Pure function 으로 프로그램을 구축. 
Pure function은 Side Effect(부수효과: 정해진 결과를 돌려주는 것 이외의 어떤 일)가 없는 함수이며,
Side effect의 예는 다음과 같다.
- 변수를 수정한다.
- 자료구조를 제자리에서 수정한다.
- 객체의 필드를 설정한다.
- 예외를 던지거나 오류를 내면서 실행을 중단한다.
- 콘솔에 출력하거나 사용자의 입력을 읽어들인다.
- 파일에 기록하거나 파일에서 읽어들인다.
- 화면에 그린다.
 

Pure function 으로 작성된 함수는 Modularity(모듈성)이 증가하며, test, 재사용, 병렬화, 일반화, 분석이 쉬워짐.


### 순수 함수란 구체적으로 무엇인가?
주어진 입력으로 뭔가를 계산하는 것 외에는 프로그램의 실행에 그 어떤 관찰 가능한 영향도 미치지 않는다.
따라서 같은 입력에는 항상 같은 값을 돌려준다.
 
Referential Transparency (참조 투명성)
- Expression(표현식)[^1]의 한 속성
- 임의의 프로그램에서 만일 어떤 표현식을 그 평가 결과로 바꾸어도 프로그램의 의미가 변하지 않는다면 그 표현식은 참조에 투명한 것.
 

## 리뷰
이 책에서도 언급하였지만, 프로그래밍을 하면서 Side effect는 아예 없을 수는 없다. 
Pure function으로 작성하였을 때의 잇점으로 언급된 Modularity(모듈성)의 증가는 스칼라뿐만 아니라 다른 언어에서도 똑같이 적용된다.

마틴 오더스키의 강의 [Functional Programming Principles in Scala](https://www.coursera.org/learn/progfun1/home/welcome)에서도 
재귀함수를 많이 사용하는데, 그 이유도 함수의 side effect가 없는 참조 투명성을 강조하기 위함이다.
재귀함수는 iteration을 하면서 변화된 상태를 다음 재귀함수에서 사용할 수 있는 변수로 넘겨줄 수 있기 때문에 다른 변수의 상태를 변화시키지 않을 수 있다. 
아래 코드는 순수하지 않은 함수의 간단한 예이다. 
변수 `mutableSum`은 collection의 index에 위치하는 값을 계속 더해가면서 for loop를 돈다. 
따라서 자기 자신의 값이 계속적으로 변화된다.   
```scala
// Collection(List[Int])의 sum을 구하는 순수하지 않은 방법
val list = List(1, 2, 3, 4, 5)
var mutableSum = 0
for(i <- list) mutableSum += i
println(mutableSum)
```  
사실 이런 간단한 코드에서는 별 문제 없을지 모르겠지만, 
만약 변수 `mutableSum`이 for-loop 실행되는 1000줄 정도 앞에 있다거나, 
중간에 어떤 로직이 추가되어 계속적으로 이 변수의 상태가 변한다고 가정하자. 
그러면 코드를 디버깅하거나 해석할 때, 이 변수의 변화를 계속해서 추적해야된다.
반면에 참조 투명하다면, 변수 `mutableSum`가 변하지 않고 어떤 로직(List 원소들의 Sum와 같은 함수)에 대해서 변하지 않는 변수(Output)로만 정의되야 한다고 생각된다.
그리고 그 뒤로 추가되는 로직이 있다면, 그 로직에 필요한 input, output을 정의한 뒤 기존 정의된 변수의 직접적인 변화를 피해야하겠다.

---  
[^1]: 프로그램을 구성하는 코드 중 하나의 결과로 평가될 수 있는 임의의 코드 조각
