---
layout: post
title: Nginx logrotate
date: 2019-07-21 09:28:00 +0900
published: true
comments: true
categories: [Config]
tags: [Nginx]
---

## Nginx logrotate 설정
배경: nginx log가 한 파일에 계속 남고 있어서 용량이 점점 커지고 있었다.
```
-rw-r—r— 1 root root 211889676 2019-07-17 09:44 access.log
-rw-r—r— 1 root root   1662663 2019-07-17 09:28 error.log
```

## 내용
logrotate 적용하여, 로그 파일을 주기적으로 나눠서 남기도록 한다.

* crontab을 확인해보면 logrotate을 주기적으로 실행되는 것을 확인할 수 있다.
  * `logrotate`: 리눅스 로그 관리 프로그램
  * `nginx.logrotate`: nginx 로그 관리 설정 파일

```sh
$ vi /etc/crontab
... 다른 내용 생략 ...
0 * * * * root /usr/sbin/logrotate {nginx_root_path}/conf/nginx.logrotate
```

* nginx.logrotate 파일 확인하여 아래와 같은 설정을 추가해준다. 
  * nginx.conf 에 로그 옵션 추가되어 있는지 확인이 필요하다.
  ```
  # access log는 logs/access.log 위치에 access_format으로 남기는 설정
  access_log logs/access.log access_format; 
  ```

```sh
$ vi {nginx_root_path}/nginx.logrotate

{nginx_root_path}/logs//*.log {
  copytruncate // 지금까지 로그 내용 복사해서 백업하고, 현재 로그 파일은 비워주기 옵션
  daily // 매일
  rotate 30 // 30일 기준으로 rotate
  missingok // 지정된 위치에 로그 파일이 없어도 오류 발생하지 않음
  dateext // 로테이트 되는 로그 파일 이름 뒤에 날짜가 들어간다 예) error.log-20190716
}
```

## 기타 - logrotate 실행 테스트
crontab의 실행되기 전에 실행 테스트를 해보자.
주기적으로 실행하는 프로그램과 옵션을 그대로 사용하면 된다. 
`/usr/sbin/logrotate {nginx_root_path}/conf/nginx.logrotate`를 주기적으로 실행함으로 아래와 같이 하면 logrotate가 바로 실행된다. (`-f`: forced 실행)

```sh
$ sudo /usr/sbin/logrotate -f {nginx_root_path}/conf/nginx.logrotate
```
