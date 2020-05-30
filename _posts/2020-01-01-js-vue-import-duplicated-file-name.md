---
layout: post
title: Cannot read property 'props' of undefined 에러 메시지 해결 (Vue.js)
date: 2020-01-01 10:15:00 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, Vue, ErrorHandling]
type: note
---

## 현상
`Cannot read property 'props' of undefined` 에러가 발생
```
vue.esm.js:1356 Uncaught (in promise) TypeError: Cannot read property 'props' of undefined
    at normalizeProps (vue.esm.js:1356)
    at mergeOptions (vue.esm.js:1458)
    at mergeOptions (vue.esm.js:1467)
    at Function.Vue.extend (vue.esm.js:4803)
    at vue-router.esm.js:1753
    at vue-router.esm.js:1833
```

## 원인

- `test.js`, `test.vue` 와 같이 이름이 같은 파일들이 같은 폴더 안에 존재 
- import할 때, 확장자 생략 
  - ex. `import Test from './test'`
- minxin 할 컴포넌트를 js 파일로 가져와서 mixin하려고 해서 발생하는 이슈

## 해결 방법
- 파일 명을 다르게 가져가거나
- import 할 때 파일 확장자 명시

## 참고
- [Error Vue.js “Cannot read property 'props' of undefined”](https://stackoverflow.com/questions/46239040/error-vue-js-cannot-read-property-props-of-undefined)
  - `mixin: []` 내 import할 파일 이름 잘못 써도 위와 같은 에러 메시지 발생한다고 함