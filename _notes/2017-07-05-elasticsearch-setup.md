---
layout: post
title: How to setup Elasticsearch v5.4.3 in ubuntu
date: 2017-07-05 12:19:57 +0900
published: true
comments: true
categories: [Config]
tags: [Elasticsearch]
---

## Overview
Elastic Search v5.4.3 (설치 시점인 2017.06.29자 최신버전)를 우분투에 설치

## Prerequisites
Setting environment before install elastic search
- 자바8 oracle-java8-installer 설치
```sh
# repository 추가
$ sudo add-apt-repository ppa:webupd8team/java
# repository index 업데이트
$ sudo apt-get update
# JDK 설치
$ sudo apt-get install oracle-java8-installer
```
[참고](http://sarghis.com/blog/1050/)

## Install
### Using [APT](https://en.wikipedia.org/wiki/APT_(Debian))
- Install
```sh
# Import the Elasticsearch PGP Keyedit
$ wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Installing from the APT repository
$ sudo apt-get install apt-transport-https
$ echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
$ sudo apt-get update && sudo apt-get install elasticsearch
```
[참고](https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-repo)

- Run 
    + APT로 설치시, 자동으로 service로 등록됨.
    + 기본 port는 9200.
```sh
$ sudo service elasticsearch start
```

### Using zip file

```sh
// 다운로드
$ wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.zip

// unzip
$ unzip elasticsearch-5.4.3.zip

// In case unpacking for tar.gz
// $ tar -xzf elasticsearch-5.4.3.tar.gz

// Running Elasticsearch
$ cd elasticsearch-5.4.3/
$ bin/elasticsearch
```
- 다운로드: [Elastic Docs](https://www.elastic.co/guide/en/elasticsearch/reference/current/zip-targz.html#zip-targz)
와 같이 [Elastic 제품 다운로드 페이지](https://www.elastic.co/kr/downloads/past-releases)에서 원하는 버전을 찾아 zip, tar 파일을 받아서 풀면 됨.
- Running environment setting: [DigitalOcean tutorial 환경 설정](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-14-04)
- Running optoins
    + `bin/elasticseach` 명령어로 돌릴 경우, 해당 콘솔 창을 종료하면 같이 종료됨. 
    + -d: 백그라운드로 run
    + -p {파일명}: 프로세스 아이디 파일로 출력
    + 예:
    ```sh
    $ bin/elasticsearch -d -p pid
    ```

## Elastic search setting
- 초기 설정 파일: `config/elasticsearch.yml'
- 외부 접근 설정
```yaml
network.host: {ip}
network.bind_host: {ip}
```

## Elastic search site plugins
Elastic Search의 상태를 웹 상에서볼 수 있도록 해줌. 각종 쿼리를 실험해볼 수 있음.
- [Elasticsearch 5.0에서 사이트 플러그인 실행](https://www.elastic.co/kr/blog/running-site-plugins-with-elasticsearch-5-0)
- [mobz/elasticsearch-head](https://github.com/mobz/elasticsearch-head#running-with-built-in-server)
- [Head Plugins 설치 및 구동](http://jjeong.tistory.com/1202)
