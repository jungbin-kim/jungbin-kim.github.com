---
layout: post
title: Check an expiration date of PEM file on ubuntu
date: 2018-05-15 06:51:26 +0900
published: true
comments: true
categories: [Linux]
tags: [SSL, Ubuntu]
type: note
---

## Ubuntu에서 PEM 파일 만료 기간 알아보기
Ubuntu에서 특정 PEM 파일에 대한 만료 기간을 알아보고 싶을 때, 
[openssl](https://www.openssl.org/)을 사용.
```sh
$ openssl x509 -enddate -noout -in {file path/file.pem}
notAfter=Dec 28 23:59:59 2016 GMT # 결과
```

{% reference https://stackoverflow.com/a/21297927 %}
