---
layout: post
title: How to setup user login in CentOS v7.3 64bit
date: 2017-10-06 21:55:00 +0900
published: true
comments: true
categories: [Linux]
tags: [Setup, centos]
type: note
---

## Overview
CentOS v7.3 64bit에 다음과 같은 설정을 진행한다.
1. user 생성 
2. local ssh keygen을 이용한 private/public key user 로그인
3. 생성된 user sudo 권한 부여

## User 생성
```sh
# user 추가 및 password 설정
[root@dev ~]$ useradd {user id}
password for {user id}: #Enter password

# user home directory 생성 확인
[root@dev ~]$ ls /home
{user id}
```
[참고: users add 명령어](https://www.centos.org/docs/5/html/5.1/Deployment_Guide/s2-users-add.html)

## Set public key authentication
private key는 local에 public key는 server의 user home directory 내 지정된 path에 넣어서
인증 받은(private key가 있는) local만 ssh로 server에 접속 할수 있도록 한다.

1. `local` ssh key를 생성 private, public 파일 생성
    ```sh
    # In my case, local is macOS
    $ ssh-keygen -t rsa -C "USERNAME@mail.com"
    ```
이후 질문은 모두 엔터만 입력 

   + 옵션 -t: 암호화 타입 설정 (dsa, ecdsa, ed25519, rsa, rsa1)
   + 옵션 -C: Comment (여기서는 user mail이며 서버에 따라 다른 용도로 사용 가능한듯)

2. `local` 생성된 private, public key 확인 및 public key 복사
    ```sh
    # private, public key 생성 확인
    $ ls ~/.ssh/
    id_rsa		id_rsa.pub
    
    # public key 내용 확인 
    $ cat ~/.ssh/id_rsa.pub
    # 나온 내용 복사
    ``` 

3. `server` user home directory 내 public key 등록
    ```sh
    # 추가한 user home directory 이동 및 .ssh 폴더 생성 
    [root@dev ~]# cd /home/{user id}
    [root@dev {user id}]# mkdir -m 700 .ssh
    [root@dev {user id}]# cd .ssh
    
    # 복사한 local의 id_rsa.pub을 authorized_keys 파일에 넣음 (파일이 없으면 생성됨)
    [root@dev .ssh]# echo '{Paste a copied id_rsa.pub}' >> authorized_keys
     
    # authorized_keys 파일에 권한 설정
    [root@dev .ssh]# chmod 600 authorized_keys
    ```
이 단계를 진행하다가 authorized_key 파일을 dir로 만들고 그 안에다 id_rsa.pub 파일을 넣는 실수를 하였음.
authorized_key 자체가 파일임.

4. `server` public key authentication 설정
    ```sh
    [root@dev ~]# vi /etc/ssh/sshd_config
    # 다음과 같이 설정 변경
    RSAAuthentication yes
    PubkeyAuthentication yes
    
    AuthorizedKeysFile      .ssh/authorized_keys
    ```
    
5. `server` sshd 재시작
    ```sh
    [root@dev ~]# service sshd restart
    ```

6. `local` ssh public key 방식으로 `server` 접속
    ```sh
    $ ssh -p {ssh port} -i {id_rsa path} {user id}@{ip}
    ```
    
    + 옵션 -p: ssh 접속 port를 서버에서 변경하였을 경우 설정해줌 (default: 22)
    + 옵션 -i: 서버의 public key와 매칭되는 private key file path (예: ~/.ssh/id_rsa)
    + 옵션 -v: 서버 접속 오류 날 경우 디버깅 하기 위한 디버깅 모드 설정
    
- [서버 설정 참고](http://javaworld.co.kr/62)
- [ssh-keygen 참고](http://storycompiler.tistory.com/112)

## 생성된 user sudo 권한 부여
생성된 user에게 sudo 권한을 직접 부여하는 방법도 있지만, admin 그룹을 만들어서 관리하는 방법 사용.
sudo 관련하여 `/etc/sudoers` 파일에서 설정한다고 되어 있어 파일을 열어봄.
```sh
[root@dev ~]# vi /etc/sudoers
... 파일 내용 ...
## This file must be edited with the 'visudo' command.
...

[root@dev ~]# visudo
# 이전 명령어와 똑같은 내용의 파일이 열리며, 다음 내용을 추가한다.
%admin  ALL=(ALL)       ALL

# admin 이라는 이름의 그룹 추가
[root@dev ~]# groupadd admin

# group에 user id 추가
[root@dev ~]# usermod -a -G admin {user id}

# user에게 group이 추가되었는지 확인
[root@dev ~]# id {user id}
```

[참고: CentOS에서 admin 그룹 유저에게 root 권한 부여하기](https://m.blog.naver.com/PostView.nhn?blogId=ships95&logNo=220232373983&proxyReferer=https%3A%2F%2Fwww.google.co.kr%2F)