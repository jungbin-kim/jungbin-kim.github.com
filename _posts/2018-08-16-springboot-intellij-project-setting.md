---
layout: post
title: Setting Spring boot project on IntelliJ
date: 2018-08-16 21:02:15 +0900
published: true
comments: true
type: post
categories: [Spring]
tags: [Spring boot, IntelliJ]
---

## Spring boot 프로젝트 IntelliJ 에 세팅하기
Play framework in Scala 를 사용하다 아래와 같은 이유로 Spring boot 프로젝트를 시작.
- 커뮤니티나 레퍼런스의 양이 많음
- 개발자를 구할 경우 Scala + Play 보다는 Java + Spring 이 개발자를 구하기 쉬움.
- 다른 참고 글
    + [What are the best Java web frameworks?](https://www.slant.co/topics/40/~best-java-web-frameworks)
    + [Plqy2 vs Spring boot](https://www.slant.co/versus/157/158/~play-2_vs_spring-boot)

> 스프링 프레임워크 기반. 개발 방식을 단순화 함. 바로 돌려볼 수 있는 스프링 기반 앱을 쉽게 작성할수 있고, 서버가 내장된 단독형 애플리케이션도 100% 실행 가능한 형태로 개발 할 수 있음.

## 스프링 부트 CLI 설치
단순히 앱 실행뿐만 아니라 필요한 폴더 구조를 초기화하고 자동 생성하는 용도인 스프링 부트 CLI 설치(for MacOS).
```sh
$ brew tap pivotal/tap
$ brew install springboot
```

## 스프링 부트 프로젝트 시작하기
위에서 설치한 CLI로 프로젝트에 필요한 초반 설정(Maven or Gradle)이나 Dependency library들을 UI로 선택하여 프로젝트 시작할 수 있음.
본 글에서는 Gradle 사용.
```sh
# spring init --build gradle -d{dependency lib keyword} {project name}
$ spring init --build gradle -djpa,security,flyway,lombok myFirstApp
```
IDE를 이용하여 시작하는 방법
- IntelliJ의 경우, `File > New > Project... > Spring Initializr` 를 사용.
- 이클립스 같은 경우, STS(Spring Tool Suite, 스프링 도구 모음) 플러그인 설치하여 만들 수 있음.

## IntelliJ 개발 환경 세팅
### RUN Spring boot project
최상단 메뉴 `Run > Edit Configurations...`으로 이동 후 `Spring Boot` 추가.
그리고, Project 에서의 Main class 위치 설정.

### Hot swapping(자동으로 코드 수정사항 반영한 Reload)
**1.** spring-boot-devtools를 라이브러리에 추가하고, `build.gradle` 설정에 아래 내용 추가.
```gradle
apply plugin: 'idea'

dependencies {
    compile("org.springframework.boot:spring-boot-devtools")
}

idea {
    module {
        inheritOutputDirs = false
        outputDir = file("$buildDir/classes/main/")
    }
}
```

**2.** IntelliJ 에서 `cmd + shift + A` > `Registry...` 검색 및 선택 > `compiler.automake.allow.when.app.running` 옵션 체크

{% include figure_with_caption.html
   url='/img/posts/2018-08-16-springboot-intellij-project-setting-1.png'
   width='70%' %}

{% include figure_with_caption.html
   url='/img/posts/2018-08-16-springboot-intellij-project-setting-2.png'
   width='70%' %}

**3.** 최상단 메뉴 `Run > Edit Configurations...`에서 `Spring Boot > Running Application Update Polices` 아래와 같이 변경
{% include figure_with_caption.html
   url='/img/posts/2018-08-16-springboot-intellij-project-setting-3.png'
   width='70%' %}

**4.** Preferences 를 열고 (`cmd + ,`), `Compiler`에서 `Build project automatically` 옵션 체크
{% include figure_with_caption.html
   url='/img/posts/2018-08-16-springboot-intellij-project-setting-4.png'
   width='70%' %}

**5.** IntelliJ 재부팅

Hot swapping 설정 참고
- [Using Spring Boot 파트의 Developer Tools](https://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-devtools.html)
- [Spring and Spring Boot in IntelliJ IDEA 2018.1](https://dzone.com/articles/spring-and-spring-boot-in-intellij-idea-20181)
- [Spring boot 실시간 hot deploy하기](http://krksap.tistory.com/1157)
- [SpringBoot HotSwap with IntelliJ](http://lhb0517.tistory.com/entry/SpringIntelliJ-SpringBoot-HotSwap-with-IntelliJ)


## Error Handling

### 기본 포트인 8080 포트 사용 중인 경우
최상단 메뉴 `Run > Edit Configurations...`에서 `Environment variables`에 Name => `server.port`, value => `7070`으로 넣어줌.
또는, `application.properties` 에 `server.port = 7070`

### 자바 라이브러리 위치 못 잡는 에러
아래 에러가 발생하는 경우 `gradle clean`
> objc[72278]: Class JavaLaunchHelper is implemented in both /Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/bin/java (0x109c944c0) and /Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home/jre/lib/libinstrument.dylib (0x10ac814e0). One of the two will be used. Which one is undefined.

### Failed to determine a suitable driver class 에러
DB 관련 Dependency Library 추가한 후, 아무런 DB 설정을 하지 않으면 위와 같은 메시지가 나타나면 앱이 동작하지 않음.
Main Class Annotation으로 `@EnableAutoConfiguration(exclude={DataSourceAutoConfiguration.class})`을
추가. [참고 글](http://lemontia.tistory.com/586)

### Spring boot Run 할 경우 알 수 없는 이유로 바로 종료
`org.springframework.boot:spring-boot-starter-web` 의존성 있는지 확인하고, 없으면 추가.
[Spring Boot App이 항상 종료되는 이유](https://code.i-harness.com/ko/q/1557e57) 참고.