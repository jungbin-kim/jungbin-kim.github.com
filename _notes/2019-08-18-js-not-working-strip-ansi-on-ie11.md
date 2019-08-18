---
layout: post
title: Not working strip-ansi on IE11
date: 2019-08-18 08:00:00 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, Webpack, Polyfill]
---

## IE11에서 strip-ansi 사용 시 에러
IE11 브라우저로 접속 시, `module.exports = input => typeof input === 'string' ? input.replace(ansiRegex(), '') : input;` 지점에서 에러가 발생하면서 테스트가 불가했다. IE11에서만 발생하는 문제를 디버깅하려면 webpack으로 빌드해서 nginx도 띄우고 해야하는 번거로움이 있었다. 

처음에는 [express](https://expressjs.com/ko/)로 dev 서버를 돌려서 발생하는 문제인줄 알고, [webpack-dev-server](https://github.com/webpack/webpack-dev-server)로 변경해보았다. 하지만, 똑같은 지점에서 같은 에러가 발생하였다. 

## 해결 방법

[babel-engine-plugin](https://github.com/SamVerschueren/babel-engine-plugin) 설치하여 해결하였다.

## 원인 분석

import 된 라이브러리에서 사용한 라이브러리인 [chalk/strip-ansi](https://github.com/chalk/strip-ansi) 가 문제였다. 

[ie11 does not work](https://github.com/chalk/strip-ansi/issues/18) 라고 해당 라이브러리 github에 이슈가 있었다. 이 내용을 보면 `strip-ansi`는 브라우저 환경이 아닌 서버환경(Node.js)에서 주로 사용된다고 한다. 그래서 브라우저 환경에서 사용하려면 뭔가의 변환과정을 거쳐야하고, 그 변환 과정을 해주는 `babel-engine-plugin`을 사용해야 한다. 

크롬에선 발생하지 않았던 이유는 크롬에서 ES6 arrow functions (`input =>` 이 부분)을 지원해주기 때문이다. ([관련 참고](https://github.com/zeit/next.js/issues/2747#issuecomment-321451142))

### babel-engine-plugin

- 소스를 transpile 하는 것은 `babel-loader` 이고, 이 플러그인은 `node_modules`에 있는 모듈들(즉, 소스에서 사용하고 있는 라이브러리 디펜던시들)을 transpile 해준다. 
  - 출처: [Github babel-engine-plugin README Why 부분](https://github.com/SamVerschueren/babel-engine-plugin#why)
- transpiling은 소스를 다른 소스로 변경하는 것을 의미.
  - 예시: es6 를 es5 형태로 변경해주는 babel 
  - 출처: [Compiling vs Transpiling](https://stackoverflow.com/questions/44931479/compiling-vs-transpiling) on Stackoverflow
