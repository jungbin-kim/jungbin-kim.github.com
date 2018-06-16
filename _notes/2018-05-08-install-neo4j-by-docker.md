---
layout: post
title: Install Neo4j by Docker
date: 2018-05-08 13:35:10 +0900
published: true
comments: true
categories: [DB]
tags: [Graph DB, Neo4j, Docker]
---

## Neo4j Docker로 설치하기

테스트 서버 (OS 우분투) 내 docker에서 Neo4j [Docker Image](https://hub.docker.com/_/neo4j/)를
다운받아서 실행.(현재 Neo4j v3.3.5)

```sh
$ docker pull neo4j
$ docker run --publish=7474:7474 --publish=7473:7473 --publish=7687:7687 --volume=$HOME/neo4j/data:/data neo4j
...
INFO  Remote interface available at http://localhost:7474/
```

로컬에서 하면 웹 브라우저에서 `http://localhost:7474/`으로 접속하면되며, 
서버에서 하면 웹 브라우저에서 `http://{server ip}:7474/`로 접속하면 됨.
default password는 `neo4j`. 

- 설정 Port
    + 7474: for http
    + 7473: for https
    + 7687: Connect bolt (웹소켓으로 DB 접속하는 port 인듯)
- docker image를 데몬 모드(백그라운드)로 돌리고 싶을 경우, 
`docker run -d` 와 같이 `-d` detach 옵션을 추가해서 실행.  

### Trouble shooting
웹 브라우저로 접속하여 로그인을 할 때 다음과 같은 메시지가 나오며 로그인이 안됨.
```
WebSocket connection failure. Due to security constraints in your web browser, the reason for the failure is not available to this Neo4j Driver. Please use your browsers development console to determine the root cause of the failure. Common reasons include the database being unavailable, using the wrong connection URL or temporary network problems. If you have enabled encryption, ensure your browser is configured to trust the certificate Neo4j is configured to use. WebSocket readyState is: 3
```
검색해보니 다음과 같은 [해결책](https://neo4j.com/developer/kb/explanation-of-error-websocket-connection-failure/)이 존재.
그래서 docker run 할 때, `--env=dbms.connector.bolt.address=0.0.0.0:7687`와 같은 옵션을 넣었는데 안됨.
결국, 문제는 docker 설정 안해준게 있었음. 
Neo4j에서 로그인을 하려면 bolt port가 필요하고, 접근 가능해야하는데, 
docker에서 서버 port를 Neo4j docker image의 port와 연결해주지 않은 것임.
