---
layout: post
title: How to setup PlayFramework Environment on MacOS
date: 2017-01-07 06:45:49 +0900
published: true
comments: true
categories: [Playframework]
tags: [Scala, Play framework, Setup]
type: note
---

## Requirement
1. Play Framework 를 사용한 개발을 하기 위한 개발 환경 세팅

## Approach
1. macOS 용 패키지 관리자인 [HomeBrew](http://brew.sh/index_ko.html) 를 사용하여 자바 및 Typesafe-activator 설치


## Implementation
**1.** HomeBrew 설치[^1]

- Terminal 어플리케이션에서 아래의 코드를 실행

```bash
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
```


**2.** 자바 1.8 이상 버전 설치

- HomeBrew를 사용하여 Terminal 내에서 아래 코드 실행

```bash
$ brew cask install java
```

- 설치 후 ~/.bash_profile 에 java path 를 추가

```
export JAVA_HOME=$(/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home)
```


**3.** Typesafe-activator 설치[^1]

- HomeBrew를 사용하여 Terminal 내에서 아래 코드 실행

```bash
$ brew install typesafe-activator
```

- Typesafe-activator 설치 확인

```bash
$ activator ui
```


## References

[^1]: http://macappstore.org/typesafe-activator/ 를 참고