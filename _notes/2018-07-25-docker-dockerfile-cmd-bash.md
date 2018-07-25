---
layout: post
title: Using bash cmd on dockerfile 
date: 2018-07-25 22:08:01 +0900
published: true
comments: true
categories: [Tool]
tags: [Docker]
---

## Dockerfile 에서 CMD bash 명령어 사용하기 
DOCKERFILE 내 container 를 `docker run`할 때 서비스 시작하기 위해서 `CMD` 키워드를 사용.
하지만, `CMD service elasticsearch start`로 하였을 때 서비스가 시작하지 않았음. 
구글링 결과, `CMD service elasticsearch start && bash`와 같이 뒤에 `&& bash`를 붙여서 해결. 

### 참고
- [RUN vs CMD vs ENTRYPOINT in Dockerfile](http://blog.leocat.kr/notes/2017/01/08/docker-run-vs-cmd-vs-entrypoint)
- [How to automatically start a service when running a docker container?](https://stackoverflow.com/questions/25135897/how-to-automatically-start-a-service-when-running-a-docker-container) on Stack Overflow