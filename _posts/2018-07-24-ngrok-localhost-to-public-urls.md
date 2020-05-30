---
layout: post
title: ngrok - Tool for Public URLs
date: 2018-07-24 22:15:52 +0900
published: true
comments: true
categories: [Service]
tags: [ngrok]
type: note
---

## ngrok 로 localhost 를 Public url 로 접근
`https`를 사용해서 접근해야하는 프로젝트에서 로컬 개발 환경해서는 `https`를 따로 설정하기 힘듬.
그런데 ngrok 를 활용하면 localhost를 Public URL로 `http`, `https` 둘 다 접근 가능함.
사용 방법은 아래와 같음.

1. [ngrok](https://ngrok.com/) 회원 가입
1. ngrok를 설치 
    - 맥인 경우, 터미널에서 `$ brew cask install ngrok` 또는 zip 파일 다운로드 및 설치 (brew로 설치하는 것을 추천)
1. ngrok에 로그인해서 `Auth` 메뉴 내 `auth token` 확인 및 로컬에 auth token 설정
    - `$ ngrok authtoken {auth token}`
1. 원하는 포트를 Public URL로 설정
    - `$ ngrok http {원하는 로컬 포트}`