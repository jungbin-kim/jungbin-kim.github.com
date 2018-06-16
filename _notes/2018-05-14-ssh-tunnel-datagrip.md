---
layout: post
title: Use SSH tunnel on DataGrip
date: 2018-05-14 20:34:48 +0900
published: true
comments: true
categories: [Config]
tags: [IDE, DataGrip]
---

## DataGrip에서 SSH tunnel 사용하기

아래 그림과 같이 SSH로 접근할 수 있는 Ubuntu 서버 내 존재하는 MySQL DB를 
Jetbrain의 [DataGrip](https://www.jetbrains.com/datagrip/)으로 접근하고자 함.
외부 ip가 MySQL을 접속하는 것은 막은 상태이며, private network 내에서만 MySQL DB에 접근 가능.

{% 
   include figure_with_caption.html 
   url='/img/posts/2018-05-14-ssh-tunnel.png' 
   title='SSH tunnel 개념도' 
   description=''
   width='50%'
%}

조건을 정리하면,
- SSH로 접근할 수 있는 서버(Ubuntu) 내, MySQL DB 인스턴스 존재
- 해당 MySQL DB 에는 외부 ip가 접근 불가하며, 내부 ip로만 접근 가능 

이 경우, DataGrip과 같은 database IDE가 접근할 수 있는 방법으로는 `SSH tunneling` 이 있음.

1. Open Data Sources Menu (⌘ + ; 또는 `File > Data Sources...`)
1. Select a DB Driver (내 경우엔, MySQL)
1. Write menu `General` (Host는 Private Network 내부 ip로 작성 ex. 192.168.1.100)
1. Open menu `SSH/SSL`
1. Check `Use SSH tunnel` and Write info to access server 
    - 내 경우에는 public key를 ubuntu 서버에 등록하여 local의 private key로 SSH 접속함. 
    이 경우, `Auth type`은 `Key pair (OpenSSH or PuTTY)` 
 