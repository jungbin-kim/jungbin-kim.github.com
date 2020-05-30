---
layout: post
title: Behavior of JavaScript addEventListener
date: 2019-03-10 07:32:00 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, Vue]
type: note
---

## 개요
특정 Vue component의 `mounted`에서 component 내부 특정 DOM 들에 `addEventListener`로 이벤트 함수를 걸어줌.
이 component는 사용자가 다른 페이지로 넘어가면서 `destroyed` 됨.
이 때 component 내부 DOM들에 걸려있는 이벤트 함수를 `removeEventListener`를 통해 명시적으로 지워야 메모리에서 지워지는지(Garbage Collection이 되는지)를 조사.
이 과정에서 찾은 `addEventListener` 관련된 내용들도 같이 정리.

## Vue destroyed 와 EventListener

```js
import { map } from 'lodash-es'

...

{
  data() {
    return {
      selectedEle: null
    }
  },
  methods: {
    scrollEvent(e) {
      /* do something */
    }
  },
  mounted() {
    map(this.$el.getElementsByClassName('select_class_name'), selectedEle => {
      this.selectedEle = selectedEle
      this.selectedEle.addEventListener('scroll', this.scrollEvent)
    })  
  },
  destroyed() {
    this.selectedEle.removeEventListener('scroll', this.scrollEvent)
    this.selectedEle = null
  }
}
```
위의 코드처럼 `destoryed`에 `removeEventListener`를 명시적으로 작정해야 메모리에서 수거가 되는지 Vue component에 대해서 찾아봄.

[DOM listeners haven't been removed when vm is destroyed, is this expected?](https://github.com/vuejs/vue/issues/5187) 라는 비슷한 질문이 있었음.
- **질문 요약**: Vue 문서 상에 component가 `destroyed` 될 때 모든 EventListener들이 자동으로 제거가 된다고 나와있는데 실제로 그렇지 않은 것 같다. 
- **답변 요약**: Vue 1.x 에선 그렇지만, Vue 2.x 는 자동으로 제거하지 않는다. Vue 2.x에서는 지원하는 모든 브라우저들이 해당 EventListener들을 Garbage Collection을 해줄 수 있다.

위의 답변에 따르면 `destoryed`에 `removeEventListener`가 없어도 괜찮을 것 같지만, 일반적인 자바스크립트 관행 상 남기는 것도 괜찮을 것 같다. 

> observer 형태의 경우, 더 이상 사용되지 않을 때 명시적으로 제거하는 것이 중요합니다. 이는 과거의 경우, 특정 브라우저(Internet Explorer 6 같은)들이 순환 참조를 잘 관리하지 못해 매우 중요한 요소 중 하나였습니다. 현재 대부분의 브라우저들은 observer 객체가 더 이상 사용되지 않으면 명시적으로 제거하지 않더라도 수집합니다. 하지만 이러한 observer들을 명시적으로 제거하는 것이 좋은 관행으로 남아 있습니다.

출처: [[번역]자바스크립트에서 메모리 누수의 4가지 형태](https://itstory.tk/entry/자바스크립트에서-메모리-누수의-4가지-형태) on 덕's IT Story


## 다수의 동일한 이벤트 리스너가 하나의 DOM Element에 등록될 경우
MDN Web docs의 [EventTarget.addEventListener()](https://developer.mozilla.org/ko/docs/Web/API/EventTarget/addEventListener#%EB%8B%A4%EC%88%98%EC%9D%98_%EB%8F%99%EC%9D%BC%ED%95%9C_%EC%9D%B4%EB%B2%A4%ED%8A%B8_%EB%A6%AC%EC%8A%A4%EB%84%88) 내용을 참고하여 다음 case들을 조사

- **Case1** 이벤트 함수를 익명함수로 할 경우 
  - 익명 함수이기 때문에 이벤트 함수가 중복인 것을 알 수 없어 같은 내용일지라고 중복되서 적용됨.
  - removeEventListener 불가
- **Case2** 이벤트 함수를 외부 함수로 선언하여 사용하는 경우
  - 같은 이름을 갖는 이벤트 함수가 중복되서 등록되는 것을 브라우저가 방지
- **Case3** Case 2와 동일하나 이벤트 함수가 loop에서 계속 재할당되는 경우
  - 이벤트 함수가 같은 이름을 갖지만 실제로는 다른 함수이기 때문에 중복 등록을 방지할 수 없음.
  - removeEventListener를 할 경우 맨 마지막 등록된 이벤트 함수만 삭제.

{% jsfiddle rqxgtcv0 result,js,html %}


