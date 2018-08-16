---
layout: post
title: Only anonymous user can read elasticsearch data by x-pack
date: 2018-08-01 21:31:01 +0900
published: true
comments: true
categories: [Config]
tags: [Elasticsearch]
---

## x-pack으로 임의의 유저만 elasticsearch 데이터 read가 가능하고, 인증 받은 관리자만 데이터 수정 가능하게 만들기
[Setup Elasticsearch]({{site.baseUrl}}/notes/2017-07-05-elasticsearch-setup/) 글을 따라 설치한 Elasticsearch는 인증 받지 못한 사용자가 REST API 를 통해 데이터 조작이 가능함.
그래서, 인증하지 않은 임의의 유저(Anonymous)는 `read`만 가능하고, 인증을 통하여서만 데이터 조작이 가능하도록 함.

## x-pack 설치
```sh
$ sudo bin/elasticsearch-plugin install x-pack --batch
```

## Anonymous user 접근 권한 설정
`/etc/elasticsearch/`나 `/usr/share/elasticsearch/config/`에 있는 `elasticsearch.yml` 내 아래와 같은 정보를 추가
```yml
# create an anoynomous user to allow interaction without auth
xpack.security.authc:
  # 임의의 유저(유저 이름 anonymous)에 viewer라는 role을 줌.
  anonymous:
    username: anonymous
    roles: viewer
  # Disable default user 'elastic'
  accept_default_password: false
```

viewer에 대한 role은 `/etc/elasticsearch/x-pack/` 나 `/usr/share/elasticsearch/config/x-pack/`에 있는 `roles.yml`에서 read만 가능하게 아래와 같이 설정

```yml
viewer:
  run_as: [ 'anonymous' ] # 적용될 유저 이름
  cluster: [ "monitor" ] # 적용될 cluster들
  indices:
    - names: [ '*' ] # 허용 index를 패턴을 포함하여 정의 한다.
      privileges: [ 'read' ] # 권한은 read만 부여한다.
      query: '{"match_all": {}}' # 권한으로 열어줄 문서 목록을 쿼리로 정의한다.
```

## 관리자 계정 만들기
```sh
$ sudo bin/x-pack/users useradd {user id} -p {password} -r superuser
```

## 참고 자료
- Elasticsearch 공식 문서 내 [Anonymous access settings](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/security-settings.html#anonymous-access-settings)
- [이 글](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/security-settings.html#password-security-settings)을 참고하여 기본 유저(`elastic`)와 비밀번호 사용할 수 없게 함
- Elasticsearch HTTP / TCP Scala Client 인 [elastic4s](https://github.com/sksamuel/elastic4s)로 [사용자 인증하는 방법](https://github.com/sksamuel/elastic4s/issues/998#issuecomment-321062710)
- [Basic Authentication of ES without X-Pack](https://discuss.elastic.co/t/basic-authentication-of-es-without-x-pack/94840/5): x-pack 인증 부분은 유료이기 때문에 elasticsearch 보안을 위해서 ngix의 reverse proxy를 이용하라는 답글