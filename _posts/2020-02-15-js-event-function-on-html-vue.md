---
layout: post
title: Event Function on HTML Element & Vue
date: 2020-02-15 09:00:00 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, Vue]
type: note
---

## HTML Element와 Vue에서 Event function 바인딩 테스트
테스트 이유: Vue 에서 click event를 선언하는데, method 이름만 선언된 경우와 method 실행을 선언할 때 다른 파라미터 값을 넘겨주었다.

## Vue 에서 이벤트 바인딩
{% jsfiddle 7vzd3pxy result,js,html %}

### 1번: 메소드 이름만 선언한 경우
* 넘어온 메소드 파라미터: Event 객체
* Event 객체를 자동으로 메소드 파라미터에 넣어준다.
* HTML 이벤트 바인딩과 다른점

### 2번: 메소드 실행을 선언한 경우
* 넘어온 메소드 파라미터: `undefined`
* 아무 파라미터도 선언하지 않고 실행한 것과 동일하기 때문에 `undefined` 출력

### 3번: 메소드에 event 선언한 경우
* 넘어온 메소드 파라미터: `undefined`
* Vue 에서 이벤트 바인딩을 할 때, `@click=""` 안에 선언되는 메소드, 변수(이 경우에는 `clickEventFunction, event`)는 vue component 에서 접근 가능한 것이다.
* 하지만, event라는 변수는 component 내부에 선언되어 있지 않다. 따라서 `undefined` 를 출력
* HTML에서는 event 를 넘기면 발생한 Event 객체에 대한 정보를 넘긴다.

### 4번: 메소드에 $event 선언한 경우
* 넘어온 메소드 파라미터: Event 객체
* Vue 에서 제공해주는 명시적으로 이벤트 객체를 넘기고 싶을 때 `$event`를 이용한다.
* 이벤트 객체와 함께 다른 메소드 파라미터를 넘겨야할 때 유용하다.

## HTML 에서 이벤트 바인딩
{% jsfiddle pqav49se result,js,html %}

### 1번: 메소드 이름만 선언한 경우
* 아예 실행이 되지 않는다.
* `onclick=""` 에서 `""` 안에 있는 내용(자바스크립트)을 실행해주는 것과 동일하기 때문이다. 함수 이름만 있으면 실행안되는 게 당연하다.

### 2번: 메소드 실행을 선언한 경우
* 넘어온 메소드 파라미터: `undefined`
* 아무 파라미터도 선언하지 않고 실행한 것과 동일하기 때문에 `undefined` 출력

### 3번: 메소드에 event 선언한 경우
* 넘어온 메소드 파라미터: Event 객체
* event 라는 키워드로 Event 객체를 넘긴다.
* event 다른 단어로 바꿀 경우, 정의되지 않았다고 나온다.
