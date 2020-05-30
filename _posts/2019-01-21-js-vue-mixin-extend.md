---
layout: post
title: VueJS mixin 과 extends 차이
date: 2019-01-21 10:22:01 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, Vue]
type: note
---

## VueJS mixin 과 extends 차이
### 동일 이벤트훅이 지정되었을 때의 호출 순서
- [mixins 와 extends 가 어떻게 다른 건가요?](https://www.a-ha.io/questions/44f0a2792124803d9061973990d54701) 질문 글에 대한 답변으로  [Composing Vue.js Components](https://alligator.io/vuejs/composing-components/) 글이 언급됨. 내용은 아래와 같았음.
    - ~~mixin은 부모 mixin이 호출되고 난 후에 자식 컴포넌트의 이벤트훅이 호출.~~
    - ~~extends는 그 반대.~~
- 하지만, 실제 테스트해본 결과 mixin과 extends의 LifeCycle hook 호출 순서는 `부모 > 자식`으로 같음. 
  - [공식 문서 옵션 병합 전략](https://kr.vuejs.org/v2/guide/mixins.html#%EC%98%B5%EC%85%98-%EB%B3%91%ED%95%A9)에도 extends도 mixin과 같은 병합 전략을 쓴다고 언급.

{% jsfiddle q1vcL9xb result,js,html %}

### 다중 상속 가능 여부
- mixin는 다중 상속이 가능(array로 컴포넌트를 연결)하고, 
- extends는 단일 상속만 됨(extends 프로퍼티에 컴포넌트가 객체로 들어감).

## LifeCycle hook 외 옵션 병합 
정의된 LifeCycle hook 모두 호출되는 것과 달리 `methods`, `components`, `directives`는 오버라이딩 된다. 즉 확장된 컴포넌트에서 동일한 이름으로 함수를 재정의하면 재정의된 함수를 사용한다. mixin하는 여러 컴포넌트에서 동일한 함수가 있는 경우, 배열 순서 상 나중에 등록된 컴포넌트의 함수를 호출한다.

{% jsfiddle 02L9qxhy result,js,html %}

## 느낀점
- `mixin`은 컴포넌트 간 공통 기능의 관리 측면에서 접근하는게 좋을 것 같음. 예전 자바스크립트 코드에서 기능 단위별로 모듈화하여 개발했던 것과 비슷한 것 같음.
- `extends`는 베이스 컴포넌트가 있는 상태에서 이를 확장할 때 사용. 상속으로 개념을 표현할 수는 있음. (예. 날짜를 선택할 수 있는 DatePicker 의 자식들에는 YearPicker, MonthPicker가 있다.)
  - 자바스크립트에서는 type-safe 에 대한 개념이 강하지 않아(+ Vue는 UI 컴포넌트 단위) 코드 상에서의 이득은 잘 모르겠음. 
  - 자바와 같은 경우 특정 객체를 상속한 객체 타입만 받는다던지 등과 같은 표현이 가능.

두 개념이 기능상 큰 차이가 없지만 상속 개념을 표현할 것이 아니면 다중 상속이 가능한 mixin이 더 유연한 코드가 되지 않을까 싶음.

## 참고
* [Vue 공식 문서: 믹스인](https://kr.vuejs.org/v2/guide/mixins.html)
* [UI 컴포넌트 확장](http://blog.jeonghwan.net/2018/05/12/extended-component.html)


