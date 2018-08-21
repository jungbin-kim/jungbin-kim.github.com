---
layout: post
title: How to build docker image from dockerfile
date: 2017-11-06 21:31:00 +0900 
published: true
comments: true
categories: [Tool]
tags: [Docker, Dockerfile]
---

## Overview
Docker는 Dockerfile로부터 명령어들을 읽어 image들을 자동적으로 빌드할 수 있다.
Play framework v2.5.18 for scala 프로젝트의 배포된 bin파일이 
JRE 8u151이 설치된 Oracle linux v7.2 docker image 환경에서 돌아가는지 확인하기 위하여
Dockerfile을 이용하여 docker image를 만들어봄.

## Prerequisites
이전 포스트 [How to setup docker on macOS]({{site.baseUrl}}/notes/2017-06-03-docker-setup-macos/)를
참고하여 docker-machine 내에서 작업.

## Implementation 
docker로 테스트한 과정은 다음과 같다.

### 1. Build oracle linux 7.2 docker image by using Dockerfile
- ~~docker-machine에 접속~~ [docker-machine 관련 명령어](https://gist.github.com/jungbin-kim/d0c8a41d3c72ebdace3c4d5acaa017e4#file-docker-machine-sh)
```sh
# macOS 내에서 실행되고 있는 docker Machine에 SSH 접속
$ docker-machine ssh dev
```
<span style="color:red">**NOTES:** Docker for Mac 업데이트로 인해 Docker machine에 따로 접속하지 않고 터미널에서 docker 명령어 실행 가능. (2018.08 확인)</span>

- docker-file을 만들고 이미지 빌드
{% gist jungbin-kim/d0c8a41d3c72ebdace3c4d5acaa017e4 build-dockerfile.sh %}

- Dockerfile for oracle linux 7.2 with JRE 8
{% gist jungbin-kim/d0c8a41d3c72ebdace3c4d5acaa017e4 Dockerfile-For-oraclelinux7.2withJre8 %}

### 2. Mount host directory to docker container
Host의 디렉토리를 docker container에 mount 해주어, 배포 파일을 docker container에서 접근 가능하도록 함.
play server의 port를 docker container의 port와 연결해야 서비스가 작동하는지 확인할 수 있음.
{% gist jungbin-kim/d0c8a41d3c72ebdace3c4d5acaa017e4 container-mount-host-diretory.sh %}


### 3. Deploy a project
- Download test play2.5 project at https://www.playframework.com/download
- Apply [native-packager](http://www.scala-sbt.org/sbt-native-packager/index.html) 
and distribute a project by using `sbt universal:packageZipTarball`

### 4. Test deployed file 
- Move a distributed project file to mounted directory and unzip
- `docker container 접속 > mount된 폴더 > 압축 해제한 폴더`에서 bin 파일 실행 `./bin/{project name}`

