---
layout: post
title: Import CSV file on Neo4j docker image
date: 2018-05-20 17:04:12 +0900
published: true
comments: true
categories: [Graph DB]
tags: [Docker, Neo4j]
---

## Neo4j Docker에 CSV 파일 import 하기

```sh
# neo4j의 local file들을 저장하는 폴더 생성
$ mkdir {neo4j path}/import

# 해당 폴더에 import할 csv 파일 업로드 혹은 다운로드 혹은 이동
$ mv {대상 파일 ex. neo4j_test.csv} {neo4j path}/import/

# docker run 명령어에 import 폴더 연결 명령어
$ docker run -d --publish=7474:7474 --publish=7687:7687 --publish=7689:7689 --volume=$HOME/neo4j/data:/data --volume=$HOME/neo4j/import:/import --volume=$HOME/neo4j/plugins:/plugins neo4j
```

### 참고 자료

{% reference https://stackoverflow.com/a/43607137 %} 

- [1120 - Using Load CSV in the Real World](https://vimeo.com/112447027#t=672s) from [Neo Technology](https://vimeo.com/neo4j)
<iframe src="https://player.vimeo.com/video/112447027" width="640" height="360" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

