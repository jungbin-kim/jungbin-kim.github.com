---
layout: post
title: Research libraries & Apply for play-scala unit test 
date: 2017-10-17 11:47:00 +0900
type: post
published: true
comments: true
categories: [scala]
tags: [programming, scala, test code, play framework]
---

## Overview
Play framework v2.5 for scala 에서 unit test를 적용을 위한 라이브러리 조사 및 초기 적용 방법 소개

> 유닛 테스트(unit test)는 컴퓨터 프로그래밍에서 소스 코드의 특정 모듈이 의도된 대로 정확히 작동하는지 검증하는 절차
From [wiki](https://ko.wikipedia.org/wiki/%EC%9C%A0%EB%8B%9B_%ED%85%8C%EC%8A%A4%ED%8A%B8)

## Libraries

### ScalaTest
- [ScalaTest]((http://www.scalatest.org/))는 Scala 에코 시스템에서 가장 유연하고 유명한 testing tool
- 테스트할 수 있는 대상: Scala, Scala.js, Java code

### Spec2
- [Specs2 in Play2](https://www.playframework.com/documentation/2.6.x/ScalaTestingWithSpecs2#Testing-your-application-with-specs2): 
`libraryDependencies += specs2 % Test` in build.sbt

### scalacheck-shapeless
- [Github](https://github.com/alexarchambault/scalacheck-shapeless)
- `libraryDependencies += "com.github.alexarchambault" %% "scalacheck-shapeless_1.13" % "1.1.5"` in build.sbt

### scalatestplus-play
- [Github](https://github.com/playframework/scalatestplus-play)
- `libraryDependencies += "org.scalatestplus.play" %% "scalatestplus-play" % "1.5.1" % Test` in build.sbt

## Condition
아래 조건들은 테스트 케이스를 적용할 때에 고민한 지극히 개인적인 의견임. 
* A. `DAO` 함수들을 테스트할 경우, 연결되어 있는 개발 DB에 저장하고 싶지 않다.
    + 개발 DB의 역할을 생각해보면, 굳이 테스트할 때 개발 DB에 저장하는 것을 피할 필요는 없다고 생각
    + 하지만, `DAO`의 함수 기능 테스트에서 개발 DB에 저장되다면 개발 서버 API에 문제 발생하여 협업 문제 발생. 
    `Service`단에서 여러 `DAO` 함수들을 함께 사용하기 때문.
    
* B. 테스트 데이터는 지정된 값만을 테스트하는 것이 아니라, 각 테스트하는 함수의 제한 조건에 충족하는 데이터들을 랜덤 생성하고 싶다.
    + 이름이 50자 이하면 유의미한 이름을 넣는 것이 아니라, 길이가 50 이하인 랜덤 String 생성 
    + 지정된 값만 테스트할 경우, 예외 상황이 생기는 것을 검사할 수 없을 것 같음


## Implementation
- `조건 A`를 만족하기 위해, DB config을 바꾼 서버 어플리케이션(`fakeApp`)을 실행하여, 테스트.
{% gist jungbin-kim/00469fdf365b136888017f5a344a73a3 Inject.scala %}

- test할 DAO들을 가지고 있는 `TestDaos`. `Inject`를 Mixin 함
{% gist jungbin-kim/00469fdf365b136888017f5a344a73a3 TestDaos.scala %}
      
- `조건 B`를 만족하기 위해, 테스트 함수의 입력 데이터 랜덤 생성  
    + 실제 적용시, 함수 입력 값 중 하나가 [Scala Enumeration](https://www.scala-lang.org/api/current/scala/Enumeration.html)으로 되어 있었는데, 
    그 중 하나 값에서 에러 발생하는 경우가 있었음. 
    그래서 테스트할 때 Success, Fail이 랜덤하게 발생. 테스트를 한번만 해봐서는 알 수 없다는 것도 느낌.
{% gist jungbin-kim/00469fdf365b136888017f5a344a73a3 Dao1ArbitraryModels.scala %}

- 테스트 통과/실패 조건 설정 
    + Given/When/Then 구조를 이용한 테스트
{% gist jungbin-kim/00469fdf365b136888017f5a344a73a3 Dao1Spec.scala %}

- 테스트 실행

```sh
# 모든  테스트 클래스 실행
$ sbt test

# 테스트하고 싶은 테스트 클래스만 실행
$ sbt testOnly *TestClassName
```
[testOnly 참고](https://stackoverflow.com/questions/11159953/scalatest-in-sbt-is-there-a-way-to-run-a-single-test-without-tags)
