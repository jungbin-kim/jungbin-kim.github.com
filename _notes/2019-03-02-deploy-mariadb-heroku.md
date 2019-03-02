---
layout: post
title: Heroku에서 MariaDB를 무료로 사용해보자
date: 2019-03-02 20:42:00 +0900
published: true
comments: true
categories: [Service]
tags: [Heroku, MariaDB]
---

## Heroku에서 MariaDB를 무료로 사용해보자
[Heroku에 SpringBoot App을 무료로 배포해보자](./2019-03-02-deploy-springboot-heroku/)에 이어서 DB도 무료로 사용해보기로 하였다. DB를 사용하기 위해서는 heroku addon이 필요하다. 그리고 addon을 사용하기 위해서 신용카드 등록이 필요하다. 등록하지 않고 addon create 명령어를 쓴다면 등록 후 사용하라는 메시지가 나온다. addon도 무료~유료 플랜으로 되어 있어 무료 플랜으로 사용하면 비용이 나가진 않는다.(하지만 성능은...)

Heroku Dev Center 가이드 문서인 [Deploying Spring Boot Applications to Heroku](https://devcenter.heroku.com/articles/deploying-spring-boot-apps-to-heroku)에서는 공식 지원 DB인 PostgreSQL만 나와있다. 아래 내용은 **MariaDB 연결 방법**이다.

### Heroku Addon 설정
(명령어 실행은 heroko 프로젝트 root 폴더에서 진행)
- mariaDB를 사용하기 위해 [JawsDB Maria Addon](https://elements.heroku.com/addons/jawsdb-maria)을 실행
```sh
$ heroku addons:create jawsdb-maria:kitefin
Creating jawsdb-maria:kitefin on ⬢ salty-meadow-20631... free
Database is being provisioned. Your config_var will be set automatically once available.
Created jawsdb-maria-convex-72124 as JAWSDB_MARIA_URL
Use heroku addons:docs jawsdb-maria to view documentation
```
  - 무료 플랜인 `Kitefin`는 5 MB의 스토리지를 제공해준다.

- 아래 config 명령어로 `DB URL`, `USERNAME`, `PASSWORD` 생성된 것을 볼 수 있음.
    ```sh
    $ heroku config

    === salty-meadow-20631 Config Vars
    JAWSDB_MARIA_URL: mysql://<username>:<password>@<host>:<port>/<db_name>
    ```
    - 위에서 나온 결과로 사용하는 프레임워크에 맞춰 DB 설정을 해주면 된다.


