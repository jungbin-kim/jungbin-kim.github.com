---
layout: post
title: Elasticsearch using docker build
date: 2018-08-01 21:19:02 +0900
published: true
comments: true
categories: [Config]
tags: [Elasticsearch, Docker]
---

## Docker build 로 Elasticsearch docker image 만들기
특정 이미지를 기반으로 하여 새로운 이미지를 만들 수 있는 `Docker build`에 대해 공부와 함께
이전에 ubuntu 14.04 위에 서비스로 elasticsearch 를 설치했던 내용들을 정리하기 위해 `Dockerfile`을 만듬.

해당 elasticsearch는 [x-pack](https://www.elastic.co/guide/kr/x-pack/current/xpack-introduction.html)을 사용하여,
인증받지 않은 임의의 유저는 특정 클러스터에 read 만 할 수 있도록 함.

아래 `Dockerfile`, `elasticsearch.yml`, `roles.yml`를 한 폴더에 놓은 뒤, `$ docker build` 실행.

{% gist jungbin-kim/8a3c925e7283dd3e572d9571eec16f5b %}

위와 같이 `dockerfile`을 별도로 만들지 않아도, [Docker hub](https://hub.docker.com/_/elasticsearch/)에 5.6 버전까지 docker 이미지가 있으며,
최신 버전(현재 6.3)의 elasticsearch docker image는 [공식 제공 페이지](https://www.docker.elastic.co/)에 존재.

### 사용한 docker file 명령어
- `RUN`: 쉘 명령어를 수행
- `WORKDIR`: 현재 가리키고 있는 폴더 위치 변경
- `COPY`: 특정 파일이나 폴더 docker image에 복사
- `EXPOSE`: docker container 내의 port
- `CMD`: docker image를 container로 실행할 때 실행되는 명령어 지정

### Error Handling
#### `apt-get install apt-transport-https` 명령어를 실행할 때, `Unable to locate package apt-transport-https` 에러 발생
[이 글](https://community.c9.io/t/installing-apt-transport-https-issue/10994/7)을 참고하여,
`/etc/apt/sources.list.d/` 경로에 elastic 관련 .list 파일을 삭제하고, 다시 install 명령어 실행.