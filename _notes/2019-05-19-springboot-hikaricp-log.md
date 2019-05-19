---
layout: post
title: Monitoring HikariCP Log on Spring Boot
date: 2019-05-19 12:19:00 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring boot, Java]
---

## 문제 상황
배포 이후, 지속적으로 DB Connection이 증가하여 DB와의 연결이 끊어지는 문제가 발생하였다. 특정 API에서 DB Connection이 정상적으로 종료되지 않고, sleep 상태로 가기 때문이었는데, 이를 확인하기 위해서 Connection Pool을 log로 관찰할 필요가 있었다.

## HikariCP
> "zero-overhead" production ready JDBC connection pool.

Spring boot 1.x 와는 다르게 Spring boot 2.x 에서는 그냥 사용 가능
- `spring-boot-starter-data-jpa`에서 기본으로 포함
- [Production Database Connection 선택 룰]((https://docs.spring.io/spring-boot/docs/2.0.4.RELEASE/reference/htmlsingle/#boot-features-connect-to-production-database))
  - HikariCP가 있으면 HikariCP 사용
  - Tomcat pooling DataSource
  - 위 두개 없을 경우, Commons DBCP2 사용

## Spring Boot 설정

### Connection Pool 설정
```yml
spring.datasource.hikari.minimumIdle=5
spring.datasource.hikari.maximumPoolSize=20
spring.datasource.hikari.idleTimeout=30000
spring.datasource.hikari.poolName=SpringBootJPAHikariCP
spring.datasource.hikari.maxLifetime=2000000
spring.datasource.hikari.connectionTimeout=30000
```
idle은 `게으른, 나태한`이란 뜻으로 Connection Pool에서 대기 중인 상태.
프로퍼티들에 대한 설명은 아래 블로그에 잘 정리되어 있다.
- [스프링 부트 2.0 HikariCP 프로퍼티 설정](https://javacan.tistory.com/entry/spring-boot-2-hikaricp-property)
- [HikariCP 세팅시 옵션 설명](https://effectivesquid.tistory.com/entry/HikariCP-세팅시-옵션-설명)

### Log Level 설정
`application.properties`나 `application.yml` 설정 파일에 log level을 추가하면
```yml
logging:
  level:
    com.zaxxer.hikari.HikariConfig: DEBUG
    com.zaxxer.hikari: TRACE
```

어플리케이션 실행 중, 주기적으로 아래와 같이 Pool 상태를 알려준다:
```
2019-05-19 08:24:12.878 DEBUG 36777 --- [l-1 housekeeper] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - Before cleanup stats (total=1, active=0, idle=1, waiting=0)
2019-05-19 08:24:12.878 DEBUG 36777 --- [l-1 housekeeper] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - After cleanup  stats (total=1, active=0, idle=1, waiting=0)
2019-05-19 08:24:42.878 DEBUG 36777 --- [l-1 housekeeper] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - Before cleanup stats (total=1, active=0, idle=1, waiting=0)
2019-05-19 08:24:42.878 DEBUG 36777 --- [l-1 housekeeper] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - After cleanup  stats (total=1, active=0, idle=1, waiting=0)
2019-05-19 08:25:12.882 DEBUG 36777 --- [l-1 housekeeper] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - Before cleanup stats (total=1, active=0, idle=1, waiting=0)
2019-05-19 08:25:12.883 DEBUG 36777 --- [l-1 housekeeper] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - After cleanup  stats (total=1, active=0, idle=1, waiting=0)
```

설정 참고: [Item 58: How to Configure HikariCP via application.properties](https://dzone.com/articles/best-performance-practices-for-hibernate-5-and-spr-1) ([Github 예제 코드(application.properties)](https://github.com/AnghelLeonard/Hibernate-SpringBoot/blob/master/HibernateSpringBootHikariCPPropertiesKickoff/src/main/resources/application.properties))
