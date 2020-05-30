---
layout: post
title: Elasticsearch with Searchguard, X-Pack by using Docker compose
date: 2018-08-07 23:52:30 +0900
published: true
comments: true
categories: [Elasticsearch]
tags: [Elasticsearch, Docker, Docker-compose]
type: note
---

## Docker compose 로 Elasticsearch 의 Searchguard, X-Pack plugin 사용하기
이전에 테스트용으로 서버에 남겨놓았던 일래스틱서치의 데이터 탈취 당함. 테스트 데이터가 없어지고 인덱스에 어딘가로 돈을 보내면 데이터를 유출하지 않겠다는 메시지가 남겨져 있었음.
그래서, 일래스틱서치 보안을 적용하는 방법을 찾아봄.
[x-pack으로 인증 설정한 이전 글]({{site.baseUrl}}/notes/2018-08-01-elasticsearch-anonymous-viewer-by-xpack/)의 x-pack은 일래스틱서치사의 유료 플러그인(monitoring은 무료 사용 가능).
추가적으로 [Securing Elasticsearch](https://brudtkuhl.com/securing-elasticsearch/) 포스트와 같이 웹서버의 리버스 프록시를 이용하는 방법도 존재.

하지만, encryption, authentication 등을 제공하는 Elasticsearch 오픈 소스 플러그인인 [Search Guard Plugin](https://github.com/floragunncom/search-guard)을 적용하여 다음 요구사항을 해결하고자 함.
- 임의의 사용자는 Read 만 가능 **(Searchguard)**
- 인증 받은 관리자는 데이터 수정 가능 **(Searchguard)**
- Elasticsearch Cluster 사용 **(Docker compose)**
- Elasticsearch Cluster 상태 monitoring **(Kibana, x-pack)**

{%
   include figure_with_caption.html
   url='/img/posts/2018-08-07-elasticsearch-searchguard-xpack-structure.png'
   title='시스템 구조도'
   description='elasticsearch와 kibana의 인증은 searchguard 사용'
   width='60%'
%}

해당 작업의 결과물은 GitHub Repository (forked [deviantony/docker-elk](https://github.com/deviantony/docker-elk/tree/searchguard))에 존재.
{% reference https://github.com/jungbin-kim/docker-elk %}


### Searchguard Anonymous Readonly 설정 적용
[설정 적용 내용(Github commit)](https://github.com/jungbin-kim/docker-elk/commit/1268467ad917a5bd9d22162ab6f01b3d784590b9)은 아래와 같음.

- `elasticsearch/config/sg/sg_roles_mapping.yml`에 적용.
    ```
    sg_readall:
      backendroles:
        - readall
        - sg_anonymous_backendrole
    ```
    + [Grant read access to any index for sg_anonymous](https://groups.google.com/forum/#!topic/search-guard/9QPMRZ-o5AA) 내용 참고.

- `elasticsearch/config/sg/sg_config.yml`에서 `searchguard.dynamic.http.anonymous_auth_enabled: true` 추가

### X-Pack monitoring 과 Elasticsearch Clustering 설정
[설정 적용 내용(Github commit)](https://github.com/jungbin-kim/docker-elk/commit/7770c6c692d1e096454737d041d643f86ffea276)은 아래와 같음.
- `docker-compose.yml` 내 `elasticsearch` 서비스 옵션 변경
    ```yml
        ports: # Host 빈 포트를 랜덤으로 매핑함
          - "9200"
          - "9300"
        environment:
          ES_JAVA_OPTS: "-Xmx256m -Xms256m" # 노트북 사용시, 해당 옵션으로 clustering은 무리일 수 있음.
          discovery.type: zen
          discovery.zen.ping.unicast.hosts: elasticsearch
          xpack.monitoring.exporters.id1.host: elasticsearch # monitoring 용
    ```
    + [Elasticsearch cluster 문서](https://github.com/deviantony/docker-elk/wiki/Elasticsearch-cluster) 참고

- `elasticsearch/Dockerfile` 와 `kibana/Dockerfile`의 base image 를 x-pack 이 설치된 image 로 변경

- `elasticsearch/config/elasticsearch.yml` 와 `kibana/config/kibana.yml`에 `xpack.monitoring.enabled: true` 추가.
`elasticsearch/config/elasticsearch.yml`에는 monitoring 대상 설정 정보인 `xpack.monitoring.exporters` 설정 또한 추가.
host 옵션은 docker compose 내에서 environment 로 추가.
    ```yml
    xpack.monitoring.exporters:
      id1:
        type: http
        auth.username: admin # monitoring을 수행할 사용자 searchguard에서 설정한 사용자 정보를 사용
        auth.password: admin
    ```
    + [Elasticsearch x-pack HTTP Exporter Settings](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/monitoring-settings.html#http-exporter-settings)


### 실행
```sh
# Docker compose 에 필요한 코드 다운로드
$ git clone https://github.com/jungbin-kim/docker-elk.git
$ cd docker-elk

# docker compose에 선언된 서비스들 실행
# -d는 background로 돌리는 옵션.
# --scale {서비스 이름}={실행할 컨테이너 수}
$ docker-compose up --scale elasticsearch=3 -d

# searchguard 인증 적용
$ docker-compose exec -T elasticsearch bin/init_sg.sh
```
- docker-compose 에서는 하나의 서비스를 여러 컨테이너로 돌릴 수 있는 scale 옵션을 제공하여 scale out 가능.
ex) `$ docker-compose up --scale elasticsearch=3` 명령어는 docker-compose 파일에 정의된 elasticsearch 서비스는 container 3개로 실행되며, 나머지는 하나씩.

### 결과

{%
   include figure_with_caption.html
   url='/img/posts/2018-08-07-elasticsearch-kibana-result.png'
   title='Cluster monitoring 결과'
   description=''
   width='60%'
%}

## 기타
### Host reboot에 따른 자동 재시작 방법
docker-compose 파일 내 service 항목 하위로 `restart: always` 옵션만 넣어주면 됨.
[해당 쓰레드](https://github.com/docker/compose/issues/872#issuecomment-87210436)를 보면 docker 명령어로만 restart가 설정된 container를 죽일 수 있다고 함.
(위에는 안된다는 사람도 있다.)

### Searchguard 사용자 비밀번호 바꾸기
`elasticsearch/config/sg/sg_internal_users.yml`에는 searchguard의 사용자 정보가 존재.
비밀번호(hash 옵션)는 salted BCrypt hash 로 되어 있음.

```sh
# docker-compose로 인해 서비스들이 돌아가고 있는 상태에서 elasticsearch 서비스 container에 접속.
$ docker exec -it {elasticsearch docker container 이름} /bin/sh

# 접속후 다음과 같이 password를 BCrypt 함.
$ plugins/search-guard-6/tools/hasher.sh -p {password string}

# 위에서 나온 hash 패스워드를 원하는 계정 hash에 업데이트
$ vi config/sg/sg_internal_users.yml

# docker container 접속 종료
$ exit

# 바뀐 비밀번호 적용
$ docker-compose exec -T elasticsearch bin/init_sg.sh
```

### Docker memory 부족
[Docker Container exited with code 137](https://www.petefreitag.com/item/848.cfm) 에러는 Docker memory 부족하여 발생하며, docker container가 종료되는 증상이 나타남.
해결 방법은 각 서비스가 사용하는 메모리 할당을 줄이고, Docker for Mac의 사용 가능 memory 를 더 높이는 것.


## 다른 구성 방법

{%
   include figure_with_caption.html
   url='/img/posts/2018-08-07-elasticsearch-searchguard-xpack-structure-for-work.png'
   title='다른 구성의 시스템 구조도'
   description=''
   width='60%'
%}

- Elasticsearch, Kibana docker container의 Data Volume을 Host path와 매핑하여 데이터들을 저장.
    + 이 글 설정은 Docker local volume 에 저장.
    + scale 사용시, 컨테이너마다 각기 다른 Host volume 과 매핑 불가함.
    `--scale` 옵션 사용하면 하나의 서비스가 scale 값에 따라 실행 컨테이너 수가 증가.
    실행 컨테이너들의 Data Volume 각각을 서로 다른 host path와 연결하고자 함
    [해당 쓰레드](https://github.com/moby/moby/issues/31671)를 보면 이러한 Docker compose 옵션은 미개발 상태로 보임.
    그와 반대로, [되는 방법을 소개한 글](https://github.com/rexray/rexray/issues/804#issuecomment-377797386)도 있지만, 그 아래 댓글과 마찬가지로 실패.
    **결국, scale 옵션 사용을 안하고 하나의 서비스가 아닌 여러 서비스를 만들어 서로 다른 Host volume과 연결하도록 설정.**

- Elasticsearch의 Master Node만 Host의 9200 포트로 접근하고, Data Node는 docker networks 내부 ip로만 접근.
    + 이 글 설정은 Docker networks가 명시적이지 않고 자동 배정됨.
    + 위의 volume과 마찬가지로 서비스를 늘리고, docker networks를 명시적으로 배정. 그리고 마스터 노드인 컨테이너만 외부 포트와 연결.