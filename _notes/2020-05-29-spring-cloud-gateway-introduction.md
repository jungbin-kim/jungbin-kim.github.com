---
layout: post
title: Introduction Spring Cloud Gateway
date: 2020-05-29 14:07:00 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring Cloud]
---

## Spring Cloud Gateway 소개
마이크로 서비스 아키텍처에서는 여러 마이크로 서비스 어플리케이션들로 구성되어 있으므로 각각 서비스 어플리케이션에서 공통 기능(하나의 서버 어플리케이션에서 Filter로 처리하던 기능들)을 구현해야하는 힘든 점이 있다.
그러한 공통 기능을 Gateway 서비스를 통해서 하나의 진입점에서 처리해줄 수 있다. 
Spring Cloud Gateway는 Gateway 서비스를 구현할 수 있는 Spring 프로젝트이다.

### 목적
* API를 라우트하는 단순하고 효과적인 방법을 제공한다. 또한, security, monitoring, metrics, resiliency 등 횡단 관심(`cross cutting concerns`)을 제공해준다.
  * Resiliency: 어플리케이션이 장애 상황에서 다시 정상 상태로 돌아가거나 사용자 관점에서 기능성을 유지 할수 있는 능력. 
  * 횡단 관심: 서로 다른 기능(물품 조회, 회원 조회 등)들 중에서 로깅, 인증 등과 같이 공통으로 필요한 기능

### 동작

![](https://cloud.spring.io/spring-cloud-gateway/reference/html/images/spring_cloud_gateway_diagram.png)

* Gateway Handler Mapping: Client의 요청에 일치하는 route를 찾아 Gateway Web Handler로 보낸다.
* Gateway Web Handler: 요청과 관련된 filter chain 을 통과하여 요청을 실행한다.

Spring Cloud Gateway `application.yml` 설정 예시:
```yml
spring:
  cloud:
    gateway:
      routes:
      # 이 부분이 하나의 route이다.
      - id: host_route
        uri: https://example.org # 목적지 Uri
        predicates: # 이 조건들을 가질 때, 위 목적지 Uri로 라우트해준다.
        - Host=**.somehost.org 
        filters: # 정의된 필터들을 거친다. 
        - AddRequestHeader=X-Request-red, blue # 목적지 Uri에 요청할 때 헤더에 X-Request-red: blue 를 추가하여 보낸다.
```
* 여기서는 yml 설정으로 설명했지만, 코드 베이스로도 route 설정이 가능하다.
* Spring Cloud Gateway 의 코드가 어떻게 구현되어있는지 보면 좀 더 쉽게 이해가 된다.

## Netflix Zuul과 비교
* Netflix 에서 제공하는 Zuul 라이브러리도 Spring Coud Gateway 와 유사한 기능을 제공한다.
* Zuul v1([spring-cloud-netflix 2.2.x](https://github.com/spring-cloud/spring-cloud-netflix/tree/2.2.x))이 Spring 도입 이후, 비동기를 지원하는 Zuul v2 이 나왔다. 하지만 Spring Cloud 에코 시스템에 맞지 않아, Spring Cloud Gateway 를 만들었다.
  * spring-cloud-netflix github `v2.2.x` branch 를 보면 zuul core v1 을 사용
  * spring-cloud-netflix github `master` branch (v3.0.0.M1)을 보면 zuul을 찾아볼 수 없다. (2020.05.29 기준)
  * [Spring Cloud Greenwich.RC1 available now](https://spring.io/blog/2018/12/12/spring-cloud-greenwich-rc1-available-now) 내용을 보면 `spring-cloud-netflix-zuul` 은 새로운 기능을 추가하지 않는 모듈 대상에 포함되어 있다. 
  * 참고: [Spring Cloud Gateway Tutorial](https://medium.com/@niral22/spring-cloud-gateway-tutorial-5311ddd59816)
* Zuul v1
  - 서블릿 프레임워크 기반
  - 서블릿 시스템은 블록킹과 멀티쓰레드이며, 커넥션 당 하나의 쓰레드를 사용해서 요청을 처리
* Zuul v2
  * Spring 과 함께 사용하기 힘들다. 
* 성능 벤치 마크([spencergibb/spring-cloud-gateway-bench](https://github.com/spencergibb/spring-cloud-gateway-bench))를 보면 zuul 보단 성능 면에서 좋다. (시간이 좀 지난 데이터이긴하다.)

나름 결론:
* 다른 Spring mircroservices 이나 Spring reactive(Non-Blocking) 쓰고 싶으면 Spring Cloud Gateway 를 사용

## 참고
[Spring Cloud Gateway official docs](https://cloud.spring.io/spring-cloud-gateway/reference/html/#gateway-how-it-works)