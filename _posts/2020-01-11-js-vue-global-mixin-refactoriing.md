---
layout: post
title: Refactoring Vue Global Mixin Component 
date: 2020-01-11 20:13:21 +0900
published: true
comments: true
categories: [Web]
tags: [Vue, JavaScript]
type: post
---

# 배경
프로젝트가 시간에 지남에 따라 Vue Global mixin 컴포넌트가 방대해졌고, 특정 도메인 컴포넌트에서만 쓸 것 같은 기능들이 들어간 것을 발견하였다. 이를 분리하면서 생각했던 내용들을 정리하였다.

# Global Mixin
Vue mixin은 컴포지션(Composition)을 통해 다른 컴포넌트의 정의된 속성(methods, computed, created 등)을 가져와 합치는 기능이다. 이를 전역적으로 컴포지션해서 쓰는 것이 `Global mixin`이다. 

진입점(`app.js` 또는 `index.js` 등)에서 직접 mixin을 한다: 
```js 
import Vue from 'vue';
import Common from './mixins/Common.vue';

Vue.mixin(Common); 
```

`Common.vue`의 정의된 속성들을 어느 컴포넌트에서나 `this`로 접근하여 사용이 가능하다. 이곳에 선언되면 전역적으로 의존성을 갖게 된다. 정의된 속성이 어디서 사용되는지는 `Common.vue`만 봐서는 알 수 없고, 전체 컴포넌트 대상으로한 검사가 필요하다.

# 리팩토링의 어려움
이미 시간이 많이 지난 프로젝트의 경우
* 개발한 사람도 이 함수가 어디서 사용되고 있는지, 왜 만들었는지 기억하지 못할 수 있다.
* 코드 단위의 인수인계를 받지 못했다면 (사실 받았더라고 해도...) 무엇을 위해 전역으로 선언된 함수인지 알 수 없다.

# 고찰
* 만약 이 기능이 전역적으로 사용될 수 있을 것 같다 싶을때도 지금 당장 그렇지 않으면 해당 컴포넌트에서만 사용한다. 각 컴포넌트들에서 중복적으로 발생함을 발견하고 나서 이를 묶어줘도 될 것 같다. 묶어줘야할 것이 발생한 경우도 Gobal Mixin까지 사용하지 않고도 특정 도메인의 공통 기능일 경우가 더 많다.
  * 관련 기능을 묶어서 특정 컴포넌트에서만 컴포지션할 수 있는 mixin 컴포넌트로 분리한다.
  * 다른 컴포넌트에서 직접 사용되지 않는 함수(mixin 내부에서만 사용되는 함수)는 노출하지 않는 방법(또는 스타일)을 적용한다.
* Global mixin에 존재하다가 사용되는 곳이 없는 줄 알고 삭제할 가능성도 있기 때문에, 리펙토링 후에는 테스트 또는 QA를 잘 해보는게 중요하다. 
* 코드의 단순 동작 같은 경우는 왠만해서는 코드보고 해석할 수 있다. 그래서 코드 인수인계를 할 때는 개발한 사람의 의도 또는 기능의 스펙을 설명하는게 좋을 것 같다. 코드 리뷰가 잘 되고 있다면 이는 테스크 단위로 협업자들과 공유될 것 같다. 
  * 테스트 기반의 개발의 필요성을 느꼈다. 

## mixin의 private function 처리
mixin 컴포넌트 내 함수 중에는 컴포넌트 내에서만 사용되고 외부에서 사용되지 않을 수 있다. 자바에서 private 접근자로 외부에서의 접근을 막는 것과 같이 Vue 컴포넌트에서도 그런 기능을 제공해주는지 찾아보았다. 

[Vue 스타일 가이드 'Private 속성 이름'](https://kr.vuejs.org/v2/style-guide/index.html#Private-%EC%86%8D%EC%84%B1-%EC%9D%B4%EB%A6%84-%ED%95%84%EC%88%98)을 보면, 두가지 추천 스타일이 있다.

속성 이름 앞에 `$_{name scope}_{속성이름}` 붙이는 방법:
```js
var myGreatMixin = {
  // ...
  methods: {
    $_myGreatMixin_update: function () {
      /*
        이런 이름 규칙을 사용한다고 해도 다른 컴포넌트에서 접근을 못하진 않는다. 개발자들 간의 규약으로 봐야할 것 같다.
      */
    }
  }
}
```

private 함수 정의를 export 해주지 않는 방법:
```js
// Even better!
var myGreatMixin = {
  // ...
  methods: {
    publicMethod() {
      // ...
      myPrivateFunction()
    }
  }
}

function myPrivateFunction() {
  /* 
    이 경우에는 this 접근자로 mixin 내부 속성을 접근하기 힘들다.
    bind 등의 scope 변경 함수를 이용해서 this를 사용할 수 있는 방법도 있지만, 코드가 뭔가 불필요해지는 부분이 생긴다는 느낌이 든다.
  */
}

export default myGreatMixin
```




