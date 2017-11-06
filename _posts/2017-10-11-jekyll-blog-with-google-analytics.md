---
layout: post
title: Apply google analytics at jekyll blog
date: 2017-10-12 22:13:00 +0900
categories: [blog]
tags: [Jekyll, netlify, google_analytics]
---

## Overview
jekyll blog에 [google analytics](https://www.google.com/analytics/)를 추가.
다른 블로그들에서 첨부하는 google analytics script 내용과 
google analytics 페이지에서 첨부하라고 한 script 내용과 달랐음.
결국 두 방법 다 가능한 것이어서, google analytics에서 제시한 스크립트 사용.

## Procedure
1. google analytics 가입 및 설정 <br />
[google analytics 설정 방법 참고 사이트](http://analyticsmarketing.co.kr/digital-analytics/google-analytics/268/)

2. jekyll 프로젝트에서 google analytics 스크립트 추가

## jekyll 프로젝트에서 google analytics 스크립트 추가하는 방법들
### `minima` 테마에서 적용 방법
+ 기본 테마인 [minima](https://github.com/jekyll/minima)의 
[`_includes/google-analytics.html`](https://github.com/jekyll/minima/blob/master/_includes/google-analytics.html)를
보면 웹 페이지에 삽입될 google analytics script가 제공되어 있으며, 
google analytics에서 프로젝트를 만들면 발급 받을 수 있는 tracking ID를 넣어준다.  
이는 `_config.yml` 파일에 `site.google_analytics={tracking ID}`을 추가하면 된다.

+ 여기서 [`_includes/google-analytics.html`](https://github.com/jekyll/minima/blob/master/_includes/google-analytics.html)가 
어떻게 적용되는지 살펴보면, [`_includes/head.html`](https://github.com/jekyll/minima/blob/master/_includes/head.html) 내에 
{{ "`{% include google-analytics.html " }} %}`가 존재하며, [`_includes/head.html`](https://github.com/jekyll/minima/blob/master/_includes/head.html)는
[`_layouts/default.html`](https://github.com/jekyll/minima/blob/master/_layouts/default.html)에서 include 된다.

### `minimal-mistakes` 테마에서 [적용 방법](https://mmistakes.github.io/minimal-mistakes/docs/configuration/) <br />
새로 적용한 테마에서도 적용하는 방법은 위와 비슷하다. 
하지만, google analytics에서 제공하는 스크립트를 보니 기본으로 제공해주는 스크립트와는 형태가 달라 custom 방식으로 아래 스크립트를 추가하였다.
custom 방식은 아래 html 파일을 `_includes` 폴더에 `analytics.html`이라는 이름으로 만들고,
`_config.yml` 파일 내 `google_analytics: "{tracking id}"`를 선언하면 된다. 

```html
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id={{ "{{ site.google_analytics " }}}}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '{{ "{{ site.google_analytics " }}}}');
</script>
```

### Other method <br />
[netlify에서 index.html 파일을 배포 과정에서 script 추가해줄 수 있는 기능](https://www.netlify.com/docs/inject-analytics-snippets/) 존재

## Conclusion
[netlify에서 제공하는 https](https://www.netlify.com/docs/ssl/#netlify-certificates)를 적용하여서 
google analytics 프로젝트 설정 페이지에서 분석할 도메인 설정시 프로토콜을 https 로 설정함.
하지만, local에서 테스트할 때에는 작동을 하였는데 netlify에 배포된 상태에서는 작동을 안하는 이슈가 존재. 
그래서 google analytics의 도메인 설정 시 앞에 붙는 프로토콜을 https를 http로 바꿨더니 정상적으로 작동이 됨.