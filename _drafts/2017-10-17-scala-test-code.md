---
layout: post
title: Research libraries for play scala unit test 
date: 2017-10-17 11:47:00 +0900
type: post
published: true
comments: true
categories: [scala]
tags: [programming, scala, test code, play framework]
---
 
## Overview
> 유닛 테스트(unit test)는 컴퓨터 프로그래밍에서 소스 코드의 특정 모듈이 의도된 대로 정확히 작동하는지 검증하는 절차
From [wiki](https://ko.wikipedia.org/wiki/%EC%9C%A0%EB%8B%9B_%ED%85%8C%EC%8A%A4%ED%8A%B8)

Play framework for scala v2.5에서 test code 적용을 위한 라이브러리 조사 

## Libraries

### Scala Test
- [Site](http://www.scalatest.org/)
- 테스트할 수 있는 대상 Scala, Scala.js, JavaCode

### Spec2
- `libraryDependencies += specs2 % Test` in build.sbt

### scalacheck-shapeless
- [Github](https://github.com/alexarchambault/scalacheck-shapeless)
- `libraryDependencies += "com.github.alexarchambault" %% "scalacheck-shapeless_1.13" % "1.1.5"` in build.sbt

### scalatestplus-play
- [Github](https://github.com/playframework/scalatestplus-play)
- `libraryDependencies += "org.scalatestplus.play" %% "scalatestplus-play" % "1.5.1" % Test` in build.sbt

## Implement

## Use
- `sbt`에서 테스트하고 싶은 test class만 테스트하는 명령어 *[참고](https://stackoverflow.com/questions/11159953/scalatest-in-sbt-is-there-a-way-to-run-a-single-test-without-tags)
```
testOnly *TestClassName
```
