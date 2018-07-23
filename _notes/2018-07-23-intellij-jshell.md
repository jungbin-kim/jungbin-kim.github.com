---
layout: post
title: Using JShell on IntelliJ (>= Java 9)
date: 2018-07-23 21:23:00 +0900
published: true
comments: true
categories: [Config]
tags: [IDE, IntelliJ]
---

## IntelliJ 에서 JShell Console (자바9 이상) 사용하기

1. `Open Project Settings` 단축키 (cmd + ; 또는 &#8984; + ;) 
1. `Project SDK` 에서 자바9 이상 SDK 추가 
1. 메인 메뉴 `Tools` > `JShell Console...` > `JRE` 선택 메뉴에서 자바9 이상 SDK로 수정

IntelliJ 에서 Scala를 사용할 때, `Scala Worksheet` 를 사용하면 빠르고 쉽게 함수나 문법을 테스트를 할 수 있음.

자바를 사용할 때는 그와 같은 기능을 제공해주지 않는지 찾아보다가 `JShell Console`이 있는 걸 알았음.
하지만, 자바 9 이상부터 사용할 수 있는 제한이 있음. 