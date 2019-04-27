---
layout: post
title: Cross-Origin Resource Sharing (CORS) 문제 해결 및 개념
date: 2019-04-27 16:02:00 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, CORS]
---

## 문제 상황
- 공통 컴포넌트를 라이브러리 형태로 배포해서 여러 다른 서비스(도메인)에서 임포트하여 사용
- 공통 컴포넌트에서는 데이터를 가져오기 위해서 공통 컴포넌트 관리 서버의 API를 호출 
  - ex. `https://service-a.jungbin.kim/index.html` 에서 공통 컴포넌트 라이브러리 js 파일을 임포트해서 사용. 임포트된 js 파일 내 공통 컴포넌트 렌더링 시 `https://api.jungbin.kim`의 API를 호출

브라우저 콘솔에서 다음과 같은 에러가 발생하며 요청 실패:
> Access to XMLHttpRequest at 'https://api.jungbin.kim' from origin 'https://service-a.jungbin.kim' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.

## 문제 정의 및 해결 방향 설정
- 왜 서버에 쿠키 정보를 보내지 않는가?: 브라우저 Network 창을 보니 Request에 쿠키 정보를 보내지 않음. (요청된 API는 쿠키 정보가 필요)
- 왜 CORS 에러가 나는가?: CORS에 대해서 좀 더 개념 파악이 필요.

## Cross-Origin Resource Sharing(CORS) 이란?
[Mozilla HTTP 접근 제어 (CORS) 문서](https://developer.mozilla.org/ko/docs/Web/HTTP/Access_control_CORS) 내용 필요한 부분만 정리.

> Cross-Origin Resource Sharing (CORS) is a mechanism that uses additional HTTP headers to tell a browser to let a web application running at one origin (domain) have permission to access selected resources from a server at a different origin.

- Cross-Origin Resource Sharing (CORS) 는 특정 HTTP header들을 사용하여 브라우저에게 어떤 도메인(origin)에 있는 리소스에 대한 접근 권한이 다른 도메인에도 있다는 것을 알려주는 방법이다.

- 다른 도메인에서의 요청에 대한 응답은 올바른 CORS header들을 포함해야한다. 

- CORS 에러는 보안 상의 이유로 자바스크립트 코드에서 무엇이 잘못됬는지 접근할 수 없다. 상세 정보를 파악하기 위해서는 브라우저 콘솔을 봐야한다.

- **인증된 요청과 응답**
  - 요청을 보내는 측: 기본적으로 브라우저는 XMLHttpRequest 이나 Fetch를 이용한 cross-domain Request에서 HTTP 쿠키와 HTTP Authentication 정보를 전송하지 않음. `withCredentials` 옵션을 true로 설정하여야 HTTP 쿠키와 HTTP Authentication 정보를 전송 가능. 
  - 응답을 보내는 측: 인증된 요청에 응답하는 경우, 서버는 도메인을 특정해야만 하며, 와일드 카드를 사용할 수 없음. 응답헤더인 Access-Control-Allow-Origin가 특정 도메인(ex. service-a.jungin.kim)을 명시하고 있어야함.

## 문제 해결
- Cross 도메인에 요청을 보낼 때, withCredentials 옵션이 누락되어 요청에 쿠키 정보를 보내지 못했다. 그래서 공통 라이브러리 HTTP Reqeust 코드에 `withCredentials: true` 프로퍼티를 추가하여 쿠키정보가 함께 요청되도록 하였다.
- 서버 측에서 응답을 보낼 때, `Access-Control-Allow-Origin` 헤더 정보를 설정해주지 못했다. 그래서 올바른 CORS header들을 보낼 수 있도록 설정하였다. ([Spring Bean 설정](https://stackoverflow.com/a/54559440)이나 Controller 단에서 [`@CrossOrigin`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/CrossOrigin.html) 추가.)
