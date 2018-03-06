---
layout: post
title: How to filter number at input element on AngularJS
date: 2018-03-06 21:36:54 +0900
published: true
comments: true
categories: [JavaScript]
tags: [JavaScript, AngularJS]
---

## HTML5 Input element 내 숫자만 허용하기

웹에서 어떤 항목(ex. 전화번호)은 숫자만 입력되어야 함.
아래 코드와 같이 HTML 문서 내에서 `onkeypress`를 이용하여 숫자의 키코드만 허용하는 방법으로 해결해보려 함.
{% jsfiddle so74ugg3 result,html %}

하지만, 위의 코드는 copy & paste 시 문자가 입력되며, 한글이 입력되는 현상 존재. 
그래서 아래와 같이 개선함. AngularJS v1.6.6에서 사용.
{% jsfiddle k1sx2xj5 result,js,html %}

## 참고
- [input에 숫자만 입력받기](http://naminsik.com/blog/3384)