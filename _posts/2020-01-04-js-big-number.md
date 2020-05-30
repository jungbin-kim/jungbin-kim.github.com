---
layout: post
title: Big Number on JavaScript
date: 2020-01-04 13:30:00 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, ErrorHandling]
type: note
---

## 현상
요금 계산을 js로 할 때, 999999999999999 (15자리) 이후로 자릿수가 증가할수록 정확성이 깨지는 현상이 발생

9가 반올림 되거나 8로 표현되는 현상:
```js
console.log("16자리 수", 9999999999999999) // "16자리 수", 10000000000000000
console.log("16자리 수 2", 9999999999999909) // "16자리 수 2", 9999999999999908
```

22자리 수 이상 지수 표시되는 현상: 
```js
console.log("22자리 수", 1000000000000000000000) // "22자리 수", 1e+21
```

## 분석 및 해결 방법
- Javascript에서 정수는 최대 15 자리까지 정확하다
- 정밀도 손실을 방지하려면 10진수 값을 숫자가 아닌 문자열로 직렬화
- Big number를 다루는 라이브러리 사용

개발하는 어플리케이션이 정확한 계산이 필요한 경우 라이브러리를 사용하는 것이 필요할 것 같다.
하지만, 나의 경우는 대략적인 금액을 계산하면 되었기 때문에 문자열 직렬화로 지수 표현만 방지하였다.

### toLocaleString
[toLocaleString](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toLocaleString)을 사용하여 문자열 표현

- 단위 separator , 가 존재하도록 표현: `toLocaleString()`
- 단위 seperator , 없이 표현: `.toLocaleString('fullwide', {useGrouping:false})`

{% jsfiddle 13v40xf5 js,result %}

## 참고 자료
- [문자열로 직렬화 방법](https://stackoverflow.com/a/50978675)
- [Overcoming Javascript numeric precision issues](https://www.avioconsulting.com/blog/overcoming-javascript-numeric-precision-issues)

