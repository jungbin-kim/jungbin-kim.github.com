---
layout: post
title: Test RxJs's zip method
date: 2020-02-08 09:00:00 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, RxJS]
---

## 테스트 이유
RxJS Observable.zip 으로 여러 비동기를 묶을 때, 그 개별 비동기 안에 있는 비동기도 기다리는가를 실험해보았다.
**결론은 zip은 zip으로 묶은 비동기들만 기다리고, 그 내부에서 호출한 비동기는 zip과 상관없이 실행된다**.

Vue 프로젝트와 관련된 이유:
- Vue Action 은 비동기(`Promise`)로 동작한다. 
- Vue Action 메소드 내부에서 Action을 호출할 수 있다.
- 이는 프로젝트가 복잡해질수록 Action을 호출하는 컴포넌트 입장에서 호출하는 Action 메소드 내 비동기를 컨트롤하기 힘들다.
- 이를 쉽게하는 구조를 생각하고 싶다. 

그전에 현재 상태에 대한 테스트 모델을 rxjs로 구현해보았다.

## 테스트
### 테스트 코드
```js
const { from, zip } = require('rxjs')

const sub1 = () =>
  new Promise((resolve, reject) => {
    console.log('   sub1 function begin')
    setTimeout(() => {
      console.log('    sub1 resolve')
      resolve('    sub1 resolve')
    }, 700)
    console.log('   sub1 function end')
  })

const sub2 = () =>
  new Promise((resolve, reject) => {
    console.log('   sub2 function begin')
    setTimeout(() => {
      console.log('    sub2 resolve')
      resolve('    sub2 resolve')
    }, 300)
    console.log('   sub2 function end')
  })

const main1$ = () =>
  from(
    new Promise((resolve, reject) => {
      console.log('main1 function begin')
      sub1()
      sub2()
      console.log('main1 function end')
      resolve('main1 resolve')
    })
  )

const main2$ = () =>
  from(
    new Promise((resolve, reject) => {
      console.log('main2 function begin')
      setTimeout(() => resolve('main2 resolve'), 400)
      console.log('main2 function end')
    })
  )

console.log('zip start')
zip(main1$(), main2$()).subscribe(() => console.log('zip end'))
```
- main1 은 비동기로 실행하는 sub1, sub2를 호출하고 끝난다.
  - sub1: 700ms 기다렸다가 종료
  - sub2: 300ms 기다렸다가 종료
- main2 는 자체적으로 400ms 기다렸다가 종료
- main1과 main2를 zip으로 묶어서 subscribe를 한다.

### console 로그 분석
```js
zip start
main1 function begin // main1 함수 실행
    sub1 function begin // sub1, sub2 순차적으로 비동기적으로 실행 후, 함수 자체는 끝나며 resolve 되길 기다림
    sub1 function end
    sub2 function begin
    sub2 function end
main1 function end
main2 function begin // main2 함수 실행. resovle 되기를 기다림
main2 function end
    sub2 resolve // sub2 는 300ms 이후 resolve
zip end // main2 가 끝나는 400ms 이후, main1, main2 두개가 모두 끝나있어 zip end 로그 남음.
    sub1 resolve // sub1 은 호출된지 700ms 이후에 종료되어 zip end가 보이고 나서 로그가 남음.
```
