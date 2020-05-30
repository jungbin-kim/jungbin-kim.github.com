---
layout: post
title: PostgreSQL data migration using pg_dump
date: 2018-07-28 13:45:17 +0900
published: true
comments: true
categories: [DB]
tags: [PostgreSQL]
type: note
---

## PostgreSQL pg_dump 로 데이터 이동시키기
테스트를 위해서 기존 서비스 PostgreSQL(v9.5.5)에서 가지고 있던 데이터를 다른 곳으로 옮김.

우선, 데이터를 이동시킬 대상 postgreSQL(v10.4)을 `docker`로 만듬.
Docker hub에서 PostGIS container [mdillon/postgis](https://hub.docker.com/r/mdillon/postgis/)를 설치 및 실행.
```sh
$ docker pull mdillon/postgis
$ docker run --name postgis-test -e POSTGRES_PASSWORD={password} -it -p {host port}:{container port} mdillon/postgis
```

기존 postgreSQL이 동작하고 있는 인스턴스 콘솔에서 [pg_dump](https://www.postgresql.org/docs/9.4/static/app-pgdump.html)를 실행하여 데이터를 sql 파일로 만들고 이동.
```sh
# 데이터베이스 이름이 geo인 데이터들을 유저 이름 postgres로 접속하여 sql 파일로 만들어줌
$ pg_dump -U postgres geo > geo_db.sql

# 만든 컨테이너로 데이터 이동
$ psql -U {대상 유저 이름} -h {대상 주소} -p {대상 port} -d {대상 database 이름} -f {대상 db에서 실행할 sql 파일 path}
```

### Trouble shooting
#### `Postgres: Checkpoints Are Occurring Too Frequently` Warnings
옮기는 도중에 docker container db 로그에 다음과 같은 로그가 남음.
```sh
LOG:  checkpoints are occurring too frequently (26 seconds apart)
2018-07-28 06:30:35.540 UTC [89] HINT:  Consider increasing the configuration parameter "max_wal_size".
```

wal은 [Write-Ahead Log](http://postgresql.kr/docs/9.6/wal-intro.html) 데이터 무결성을 보장하는 표준 방법.
[이 글](https://stackoverflow.com/questions/27972393/postgres-checkpoints-are-occurring-too-frequently)에 따르면,
업데이트가 bulk로 일어날 경우 발생할 수 있으며, `checkpoint_segments` 옵션을 증가하여 해결 가능하다고 함. 하지만, warnings 이기 때문에 따로 옵션을 수정하지 않음.
> Your server is generating so much WAL data due to the wal_level set to hot_standby. I'm assuming you need this, so the best option to avoid the warnings is to increase your checkpoint_segments. But they are just that - warnings - it's quite common and perfectly normal to see them during bulk updates and data loads. You just happen to be updating frequently.


#### read_only role이 없다는 Error
소스 postgreSQL 에는 `read_only` role 이 있지만, 대상 postgreSQL 해당 role 이 없어 발생.