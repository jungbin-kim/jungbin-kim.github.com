---
layout: post
title: Basic Concepts of Web Worker
date: 2018-10-09 20:53:51 +0900
published: true
comments: true
categories: [Web]
tags: [WebWorker]
type: note
---

## Web Worker 기본 개념
- `Worker` 는 생성자를 사용하여 생성하는 객체. ex) `new Worker("worker.js")`
- 위의 예의 `worker.js` 파일에는 Worker 스레드가 실행할 코드가 존재. 이는 현재 윈도우와 다른 전역 컨텍스트에서 실행됨.
그래서 Worker 내 컨텍스트에서 `window` 객체를 사용하여 전역 스코프에 접근하면 오류가 발생.

Worker 안에서는
- DOM 객체를 직접 조작 불가
- `window` 객체의 프로퍼티들이나 기본 메소드들을 사용 불가.
(사용 가능한 `Functions`과 `class`들에 대한 [Firefox 용 문서](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Functions_and_classes_available_to_workers))
- Network I/O 작업을 위한 `XMLHttpRequest`를 사용 가능.(주의: `XMLHttpRequest`의 `responseXML` 및 `channel` 속성들은 항상 `null`을 반환)

### Dedicated Worker
- `Worker`를 만든 스크립트에서만 접근할 수 있음.
- main thread 에서 `Worker`로 요청 데이터의 이동은 `postMessage()` 메소드를 사용.
- `Worker`에서 main thread 로 보낸 응답 데이터는 `onmessage` 이벤트 핸들러로 처리.
- 여기서 주고 받는 데이터는 메모리가 공유되는 것이 아니라 `복사`됨.
    + 개인적인 생각으로는 [Akka Actor](https://akka.io/)와 비슷하게 비동기로 분산 처리에 유리하도록 설계된 것 같고, 비동기 처리를 위해서 보통 사용하는 방식인 것 같음.
- 같은 부모 페이지와 동일한 `origin`에서 수행되는 한 새로운 `Worker`들을 생성할 수 있음.

### Shared Worker
- 여러 Worker 스크립트에서 접근 가능한 `SharedWorkerGlobalScope` 가 존재

## 후기
- [Git Repository](https://github.com/jungbin-kim/simple-web-worker)와 [JSFiddle](https://jsfiddle.net/jungbin/yhfj7dzg/)에 테스트 코드를 업로드.
`Web Worker` 내에서 상태값을 가질 때 자바의 `synchronized`와 같이 선언적으로 동기화를 해야하는지, 선언된 상태값이 계속해서 유지하는지가 궁금해서 테스트. 이 테스트에 대해서 추후 정리 필요.
- 어떤 상황에서 사용해야하는지, 성능면에서 얼마나 향상되는지 궁금함.
- `Dedicated Worker`만 사용해보았고, `Shared Worker`에 대한 조사 필요.

## 참고
- [Web_Workers_API(Mozilla)](https://developer.mozilla.org/ko/docs/Web/API/Web_Workers_API/basic_usage)
- [W3C School Web Worker](https://www.w3schools.com/html/html5_webworkers.asp)