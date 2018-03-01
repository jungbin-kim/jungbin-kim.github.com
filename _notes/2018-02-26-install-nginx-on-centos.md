---
layout: post
title: How to install nginx on CentOS 7
date: 2018-02-26 15:07:41 +0900
published: true
comments: true
categories: [Linux]
tags: [Linux, CentOS]
---

## CentOS 7에 nginx 설치
- Firewall 설치

```sh
# yum install firewalld
# systemctl start firewalld
# systemctl enable firewalld
```
참조: [RHEL/CentOS 7 에서 방화벽(firewalld) 설정하기](https://www.lesstif.com/pages/viewpage.action?pageId=22053128)

- CentOS에 nginX 설치

```sh
// 패키지 업데이트. 처음하면 생각보다 오래걸림
# yum -y update 

# yum install epel-release // 아래 설명
# yum install nginx 

// nginx 실행 및 시스템 reboot될때 자동 실행될 수 있도록함
# systemctl start nginx
# systemctl enable nginx
# systemctl status nginx

// CentOS 7 방화벽 세팅
# firewall-cmd --zone=public --permanent --add-service=http
# firewall-cmd --zone=public --permanent --add-service=https
# firewall-cmd --reload
```
참조: [How to Install Nginx on CentOS 7](https://www.tecmint.com/install-nginx-on-centos-7/)

참조: [epel-release 설치하기](http://faq.hostway.co.kr/Linux_ETC/7095)
> EPEL(Extra Packages for Enterprise Linux)은 Fedora Project에서 제공되는 저장소로 각종 패키지의 최신 버전을 제공하는 community 기반의 저장소

- 클라우드 플랫폼 내 존재하는 서버라면, 플랫폼 내에서의 설정 필요(접근 IP 세팅, 80포트 개방 등)