---
layout: post
title: DB Vesion Control Flyway (Java Maven)
date: 2019-03-02 15:31:00 +0900
published: true
comments: true
categories: [Java]
tags: [Flyway, Maven, Version Management]
---

## Java Maven 에서 flyway으로 DB vesion control 하기
DB schema version control 할 수 있는 [Flyway](https://flywaydb.org/)를 Maven project에 적용하는 방법 소개.

### 설정
앱 실행 시 DB 테스트 데이터를 넣어준다던지 하기 위한 작업은 프로젝트 앱 비즈니스 코드에서 사용하기 때문에 `<dependecies>` 에 flyway 라이브러리를 넣어야한다. 

하지만, 아래 소개 내용은 앱 실행과는 별도로 **maven 명령어로 실행하는 방법**이다. DB 이력 관리를 앱 실행 여부와 관계 없이 가져가기 위함이다.

- `pom.xml`에 plugins에 flyway plugin 추가
  ```xml
  <plugins>
    ...
    <!-- For Flyway -->
    <plugin>
        <groupId>org.flywaydb</groupId>
        <artifactId>flyway-maven-plugin</artifactId>
    </plugin>
    ...
  </plugins>
  ```

- flyway options 파일 생성 (옵션 파일 위치: `./src/main/resources/db/migration/flyway.conf`)
```yml
flyway.url=${url}
flyway.user=${user}
flyway.password=${password}
```
  - [flyway.conf 옵션들 상세 정보](https://flywaydb.org/documentation/configfiles)

- DB migration 할 sql 문 작성
  - `V + 버전 + __ + 설명.sql` (ex. 배포 날짜를 기준으로 형상관리하는 형태 `V190302.0__Initial.sql` from [DB도 형상관리를 해보자!](https://meetup.toast.com/posts/173))

### Maven flyway 명령어
- [Migrate](https://flywaydb.org/documentation/command/migrate): 가장 최신 버전으로 DB 스키마 Migration. 
  - Flyway의 history를 관리하는 table이 없으면 자동으로 만들어준다. 
  - 이미 실행된 migration은 그 버전 sql이 수행되도 그냥 넘어간다. 새로운 버전을 만들어 `migrate`하거나 내부 데이터가 지워져도 관계 없을 경우는 `clean` 후 `migrate`.
- [Clean](https://flywaydb.org/documentation/command/clean): 스키마 모두 삭제.
- [Info](https://flywaydb.org/documentation/command/info): 모든 migration들에 대한 상태 정보 출력
- [Validate](https://flywaydb.org/documentation/command/validate): migration을 실행하기 전에 validation 체크
- [Undo](https://flywaydb.org/documentation/command/undo): `Flyway Pro` 에서만 사용 가능. 가장 최신 적용 migration 되돌리기.
- [Baseline](https://flywaydb.org/documentation/command/baseline): 기존 존재하는 DB의 현재 상태를 기준으로 history table 생성.
- [Repair](https://flywaydb.org/documentation/command/repair): history table 수정. migration 실패 시 repair를 하고 나서 다시 migration 을 해야함.
- 사용 예:
  ```sh
  # DB migration 실행
  $ mvn -Dflyway.configFiles=/path/to/flyway.conf flyway:migrate

  # DB clean (스키마 내의 모든 테이블을 삭제하니 주의 필요!)
  $ mvn -Dflyway.configFiles=/path/to/flyway.conf flyway:clean
  ```

## 참고
- [DB도 형상관리를 해보자!](https://meetup.toast.com/posts/173)