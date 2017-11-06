---
layout: post
title: Structure for play-scala (Controller, Service, DAO)
date: 2017-10-22 19:56:00 +0900
type: post
published: true
comments: true
categories: [scala]
tags: [programming, scala, play framework, structure]
---

## Overview
Play framework v2.5 for scala (scala v2.11.7 사용) 프로젝트에서 적용하고 있었던 Controller, Service, DAO(Data access object) 구조 코드 정리와
이를 생각하다가 갑지기 궁금해진 두 가지 궁금증에 대한 해결.

1. B 객체에 Dependency injection 된 C 객체, B 객체를 Injection한 A 객체 존재 시, A에서 C로 바로 접근 가능한가?
    + 예) Controller에서 injection한 Service 객체에서, 그 Service 객체에서 injection한 DAO 객체를 접근할 수 있는지 궁금해짐.
    
2. trait 내 private value는 mixin한 객체에서 접근 가능한가?

## Curiosity & Solution
1. B 객체에 Dependency injection 된 C 객체, B 객체를 Injection한 A 객체 존재 시, A에서 C로 바로 접근 가능한가?
    + 접근 불가
    + 위 개요에서 예로 들었던 상황에서는 DAO 객체는 Service 객체와만 연결되고, Controller에서는 DAO 객체를 모르도록 분리됨.
    하지만, Service 내 선언된 함수 중 Dependency injection 된 객체를 넘겨주는 함수가 있다면 접근하게 할 수는 있음. 
      
2. trait 내 private value는 mixin한 객체에서 접근 가능한가?
    + 접근 불가
{% gist jungbin-kim/581103556a55e3f08b0ab873e7fdab4b test-trait-mixin.scala %}

## Implementation
추상 객체 즉, 아래 코드 상 `trait`으로 선언되어 있는 객체들은 하나의 설계도이자, 
Injection 될 경우에 접근할 수 있는 함수 명세(Input/Output)의 나열이다.
사수/부사수로 나뉘어서 개발할 때, 사수가 전체적인 구조, 함수 명세를 작성하면 실제 동작 로직은 부사수가 진행하는 등의 업무 분담도 좋을 것 같다. 
 
### Controllers
아래 코드에서 `SomeController` 객체에 Injection 되는 객체는 `AService` 임.
`AService`에서 `@ImplementedBy` 키워드로 구현체를 명시하였지만, interface 는 `AService`라고 할 수 있음.
그래서 `AService` 객체에서 따로 선언하지 않는 한, `SomeController` 객체에서는 `AServiceImpl` 객체가 Injection 한 객체들을 알 수 없음. 
(1번 궁금증을 이해한 방식)
 
{% gist jungbin-kim/4ee0f109ebc0fc698ca86396bcfff5b1 SomeController.scala %}

### Services
- Service 추상 객체
{% gist jungbin-kim/4ee0f109ebc0fc698ca86396bcfff5b1 AService.scala %}

- Service 구현 객체
{% gist jungbin-kim/4ee0f109ebc0fc698ca86396bcfff5b1 AServiceImpl.scala %}

### DAOs
- DAO 추상 객체
{% gist jungbin-kim/4ee0f109ebc0fc698ca86396bcfff5b1 ADao.scala %}

- DAO 구현 객체
{% gist jungbin-kim/4ee0f109ebc0fc698ca86396bcfff5b1 ADaoImpl.scala %}