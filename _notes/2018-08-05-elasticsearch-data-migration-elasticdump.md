---
layout: post
title: Migrate elasticsearch data using elasticdump
date: 2018-08-05 07:29:51 +0900
published: true
comments: true
categories: [Config]
tags: [Elasticsearch]
---

## elasticdump 이용해서 Elasticsearch 데이터 옮기기
기존 Elasticsearch 데이터를 테스트나 백업을 위해서 다른 곳으로 옮겨야함.
Data migration tool이 있는지 찾아보다가 [Elasticdump](https://github.com/taskrabbit/elasticsearch-dump) 을 발견.

### Install
npm global 설치
```sh
$ npm install elasticdump -g
$ elasticdump
```

### 사용
Elasticsearch 에는 auth가 있기 떄문에 auth option 에 대한 [문서](https://github.com/taskrabbit/elasticsearch-dump/wiki)를 찾아서 사용.
```sh
$ elasticdump \
  --input=http://username:password@localhost:9200/sourceIndex \
  --output=http://user:pass@{target host}:{target port}/{target index} \
  --type=data
```