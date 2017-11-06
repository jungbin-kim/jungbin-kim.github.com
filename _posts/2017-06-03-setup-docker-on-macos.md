---
layout: post
title: How to setup docker on macOS
date: 2017-06-03 22:17:47 +0900 
type: post
published: true
comments: true
categories: [docker]
tags: [environment, setup, 환경설정, ubuntu, docker]
---

## Overview
Docker를 brew로 macOS에 설치하는 방법에 관한 포스트.  
Docker 공식 홈페이지에서는 [Docker for Mac](https://www.docker.com/docker-mac)이라는 dmg 파일을 
[다운로드](https://store.docker.com/editions/community/docker-ce-desktop-mac) 받아
설치하는 방법을 소개함. 
Docker for Mac과 Docker toolbox의 구체적인 차이점은 [공식 문서](https://docs.docker.com/docker-for-mac/docker-toolbox/) 참고.

- Docker for Mac
    + 다른 맥 어플리케이션과 마찬가지로 `/Applications`에 설치. `/usr/local/bin`에 docker binary를 심볼릭으로 링크.
    + Virtualization solution: [HyperKit](https://github.com/moby/hyperkit)(based [xhyve](https://github.com/mist64/xhyve)/[bhyve](http://bhyve.org/))
- brew를 이용한 설치
    + brew package 관리 경로인 `/Cellar/{docker}`에 설치. `/usr/local/bin`에 docker binary를 심볼릭으로 링크해줌.
    + Virtualization solution: brew로 설치한 [xhyve](https://github.com/mist64/xhyve)를 이용 
- Docker Toolbox 
    + Docker image가 VirtualBox


## Prerequisites
Setting environment before install docker
- macOS 용 패키지 관리자인 [brew](https://brew.sh/index_ko.html) 설치
```sh
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Install
```sh
$ brew install docker docker-compose docker-machine xhyve docker-machine-driver-xhyve

# docker-machine-driver-xhyve need root owner and uid
$ sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
$ sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
```

## Run docker image
- Run docker image
    ```sh
    # macOS 내에서 실행되고 있는 docker Machine에 SSH 접속
    $ docker-machine ssh dev
    
    # ... docker machine 내로 이동
    
    # ubuntu 컨테이너 실행 및 컨테이너 접속
    $ docker run --rm -it ubuntu /bin/bash
    ```
`-it 옵션`: 컨테이너 내부에 들어가기 위해 bash 쉘을 실행하고 키보드 입력 가능 <br />
`--rm 옵션`: 프로세스가 종료되면 컨테이너가 자동으로 삭제

- Docker container command
    ```sh
    # 모든 컨테이너 상태 확인
    $ docker ps -a
    
    # 종료된 컨테이너 다시 실행
    $ docker restart {container id}
    
    # 다시 실행된 컨테이너 접속
    $ docker attach {container id}
    ``` 

