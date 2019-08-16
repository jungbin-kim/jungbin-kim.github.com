---
layout: post
title: Protecting from Clickjacking
date: 2019-08-16 10:02:00 +0900
published: true
comments: true
categories: [Config]
tags: [Nginx, Security]
---

## 클릭재킹(Clickjacking)
해킹 기법 중 하나. 관련 예방을 하지 않는다면, 웹 사이트에서 iframe 이라는 html 태그를 사용해서 주소가 다른 사이트를 불러올 수 있다.

내 블로그 주소를 예를 들어 설명하자면, `https://blog.jungbin.kim` 페이지를 다른 도메인 <span style="color:red">https://blog.jongbin.kim</span>( <= 이 도메인은 <span style="color:red">jongbin.kim</span>!!)에서 iframe으로 보여줄 수 있다는 이야기다. 실제로 내 블로그는 서버와 정보를 주고 받는 것이 없는 페이지 형태(static resource)라 위험도가 높진 않다. 하지만 만약 내 블로그가 아닌 은행 사이트라면? 은행 도메인과 비슷한 도메인으로 된 웹사이트에서 iframe으로 정상적인 은행 사이트를 보여줄 수 있다면, iframe 내부에서 불러와진 은행 서비스는 정상 동작할 것이다. 그렇기 때문에 사용자는 실제 은행 사이트처럼 사용할 수 있고 다른 사이트에 들어와있는지 깨닫기 힘들다. 그래서 로그인할 때 입력되는 정보들을 탈취하다면 큰 문제가 될 것이다. 

이러한 해킹 기법을 [클릭제킹](https://ko.wikipedia.org/wiki/%ED%81%B4%EB%A6%AD%EC%9E%AC%ED%82%B9)이라고 한다.

- Clickjacking Alias: User Interface redress attack, UI redress attack, UI redressing

## 서버측 예방 

서버 측에서 HTTP 요청에 대한 응답 Header 정보에 특정 값을 넣어, 해당 응답을 받은 브라우저가 허가되지 않은 도메인에서 iframe 으로 콘텐츠를 로딩하지 못하게 한다. 

### X-Frame-Options

- 참고: [MDN X-Frame-Options](https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/X-Frame-Options)
- html 태그 `<frame>`, `<iframe>`, `<object>` 에서 해당 도메인 리소스(예: html 페이지)를 불러와 사용할 수 있는지 여부를 정한다.
- 3가지 옵션 지원
  - deny: frame 으로 무조건 불러올 수 없다. 같은 도메인일 경우에도 접근 불가.
  - sameorigin: 같은 도메인일 경우 frame 으로 불러올 수 있다.
  - allow-from: 특정 도메인들을 frame으로 불러올 수 있도록 허용할 수 있다.
- 주의: [MDN 브라우저 호환성](https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/X-Frame-Options#Browser_compatibility)을 보면 Chrome 은 ALLOW-FROM 을 지원하지 않는다고 나온다. 그래서 아래에서 소개할 `Content-Security-Policy`와 함께 써야한다.

```
X-Frame-Options: deny 
X-Frame-Options: sameorigin
X-Frame-Options: allow-from https://example.com/
```

### Content-Security-Policy

- 참고: [구글 개발자 문서 - 콘텐츠 보안 정책](https://developers.google.com/web/fundamentals/security/csp/?hl=ko)
- 신뢰할 수 있는 콘텐츠 소스의 허용 목록을 생성할 수 있게 해주는 Content-Security-Policy HTTP 헤더를 정의하고 브라우저에는 이런 소스에서 받은 리소스만 실행하거나 렌더링할 것을 지시한다. 
- 다양한 리소스 정책 존재 (아래 목록보다 더 많음)
  - script-src: 특정 페이지에 대한 스크립트 관련 권한 집합을 제어하는 지시문
  - frame-ancestors: 현재 페이지를 삽입할 수 있는 소스를 지정한다. `<frame>`, `<iframe>`, `<embed>`, `<applet>` 태그에 적용된다. 위의 `X-Frame-Options: ALLOW-FROM`이 크롬 브라우저에서 지원하지 않기 때문에 함께 사용한다.

### nginx 적용 방법

내가 맡은 서비스(`www.toast.com`)의 경우, `toast.com` 도메인 뿐만 아니라 `dooray.com` 과 같이 다른 도메인에서도 사용 가능해야되는 요구사항이 있었다. 복수의 도메인을 허용하기 위해서는 `nginx.conf`에 다음과 같이 설정해야한다. 참고로 `*.dooray.com`만 넣으면 `dooray.com`에서는 허용되지 않는다.

```
add_header X-Frame-Options "allow-from *.toast.com *.dooray.com";
add_header Content-Security-Policy "frame-ancestors *.toast.com *.dooray.com";
```
