---
layout: post
title: Install APOC plugin for Neo4j
date: 2018-05-19 13:17:03 +0900
published: true
comments: true
categories: [DB]
tags: [Graph DB, Neo4j, Docker]
type: note
---

## APOC Plugin for Neo4j Docker에 설치하기

Neo4j에서 datetime 데이터 처리 방법을 조사하다가 해당 플러그인을 발견.
datetime을 Cypher query 문에서 parsing하거나 형식화된 값으로 바꾸기 위해서 사용.

- [APOC for Neo4j](https://neo4j-contrib.github.io/neo4j-apoc-procedures/index33.html#_using_apoc_with_neo4j_docker_image) 소개 (의역)
> Neo4j 3.0에서는 사용자 정의 프로시저 개념이 소개되었습니다. 
그것들은 Cypher 자체에서 쉽게 표현할 수 없는 기능들에 대해서 사용자가 직접 구현하여 사용할 수 있는 것입니다. 
이러한 프로시저는 Java로 구현되고, Neo4j 인스턴스에 쉽게 배포 할 수 있으며, Cypher에서 직접 호출 할 수 있습니다.
APOC 라이브러리는 데이터 통합, 그래프 알고리즘 또는 데이터 변환과 같은 영역에서 다양한 작업을 돕는 많은 (약 300 개) 프로시저로 구성됩니다.

Docker 인스턴스에 해당 플러그인을 적용하기 위해서는 다음과 같은 과정이 필요.
```sh
# neo4j의 plugins 들을 저장하는 폴더 생성
$ mkdir neo4j/plugins

# 해당 폴더에 apoc jar 파일 다운로드
$ cd neo4j/plugins/
$ wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.3.0.3/apoc-3.3.0.3-all.jar

# docker run 옵션에 --volume=$HOME/neo4j/plugins:/plugins 를 추가하여 실행
$ docker run -d --publish=7474:7474 --publish=7687:7687 --publish=7689:7689 --volume=$HOME/neo4j/data:/data --volume=$HOME/neo4j/import:/import --volume=$HOME/neo4j/plugins:/plugins neo4j
```

제대로 플러그인이 설치되었는지 확인을 하기 위해서는 neo4j browser 명령어에 `apoc.version()`를 입력

### 이전 내용
{% reference /notes/2018-05-08-install-neo4j-by-docker/ %} 
