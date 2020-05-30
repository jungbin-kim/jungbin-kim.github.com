---
layout: post
title: Make Jekyll plugin showing html meta data on an url
date: 2018-03-11 09:11:49 +0900
published: true
comments: true
categories: [Blog]
tags: [Ruby, Jekyll]
type: post
---

## Overview 
카톡이나 슬랙 등 여러 메신저에서 url을 보냈을 때, 
아래 그림(Slack)과 같이 그 url의 정보를 가져와서 미리 보여주는 기능 존재.
{% 
   include figure_with_caption.html 
   url='/img/posts/2018-03-27-slack-url.png' 
   title='Benchmarking Sample (Slack)' 
   description=''
   width='50%'
%}
{% 
   include figure_with_caption.html 
   url='/img/posts/2018-03-27-kakao-url.png' 
   title='Benchmarking Sample (KAKAO)' 
   description=''
   width='50%'
%}
블로그 글에서도 참고한 글을 표현할 때, 위와 같은 형태로 보여주고 싶었음. 
그래서 Jekyll plugin 형태로 존재하는지 찾아보았는데, 없는 것 같아 직접 만듬.

## Implementation

이러한 기능은 해당 HTML 파일에 존재하는 
[HTML Meta tag](https://www.w3schools.com/tags/tag_meta.asp) 정보들를 이용함.
이러한 Meta tag format 중에는 [Open Graph Protocal](http://ogp.me/)이 있음.
이 정보들을 가져오기 위해서 Ruby library를 찾아봄.

{% reference /notes/2018-03-08-ruby-libs-get-html-meta/ %} 

위의 라이브러리를 이용하여 URL의 HTML meta 데이터를 표현하는 Jekyll Plugin 만듬.
Jekyll의 Custom plugin은 `_plugins`에 파일을 만들고, 동작에 해당하는 코드를 구현하면 됨. 

{% gist jungbin-kim/a28fd6b4ed74faf0ccf845b16e1a51e9 reference-url.rb %}

## 참고
- [Jekyll plugin 설명 공홈](https://jekyllrb.com/docs/plugins/)
- 같은 base url 을 가지는 url에 대한 처리를 할 때 참고 
    + [Jekyll Configuration 값을 Plugin 내에서 사용하기](https://stackoverflow.com/questions/11410611/get-jekyll-configuration-inside-plugin)
    + [ruby에서 어떤 글자로 시작되는 String 찾기 (정규표현식 사용)](https://stackoverflow.com/a/4130378)
     

