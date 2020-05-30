---
layout: post
title: Unusual point of cookie on ios web browser
date: 2019-06-23 07:30:00 +0900
published: true
comments: true
categories: [Web]
tags: [Mobile, ErrorHandling]
type: post
---

# 왜 나는 눈앞의 버그를 보지 못했는가? - iOS 웹 브라우저에서 쿠키 설정 시 특이사항
[보이지 않는 고릴라 실험](https://www.youtube.com/watch?v=vJG698U2Mvo)을 아시나요?
iOS 웹 브라우저 쿠키 설정에 대한 버그를 찾아나서는 과정 중에 유사한 상황을 겪어서 공유하고자 합니다.

## 문제 상황
서비스 A(dev.jungbin.kim)과 서비스B(dev-test.jungbin.kim)은 언어 설정 공유를 브라우저 Cookie로 합니다. (도메인은 예시입니다.)

그런데 모바일 사파리에서 서비스 A에서 변경한 언어 설정이 서비스 B에서는 변경이 안되는 문제가 발견되었습니다.

* '음? 또 모바일 사파리만 이상 동작을 하는 건가?' 이전에 모바일 사파리는 iframe 관련하여 다른 브라우저들과 다르게 동작했던 적이 있어서 이런 생각을 하며 좀 더 자세히 살펴보았습니다.
* 하지만, 확인 결과 **iOS 웹 브라우저 앱(사파리, firefox, 크롬)에서는 동일한 문제가 발생하고, 안드로이드, 데스크탑 브라우저에서는 발생하지 않았습니다.**

## 디버그
디버깅을 위해 브라우저 개발자 도구를 이용하여 언어 변경 시 쿠키가 어떻게 되는지를 살펴보았습니다. 
문제 상황이 발생하는 이유는 금방 알 수 있었습니다. 

**쿠키 도메인이 모바일 사파리에서는 `dev.jungbin.kim`으로 들어가는게 문제였습니다.**

`dev-test.jungbin.kim`, `dev.jungbin.kim` 형태의 도메인들을 갖는 서비스 페이지들 간 쿠키를 공유하기 위해서는 쿠키 도메인이 sub-domain 이 없는 형태인 `jungbin.kim` 도메인을 가져야 합니다.

하지만, 쿠키를 설정하는 함수(아래 setCookie)에서는 `jungbin.kim`으로 쿠키 도메인을 정상적으로 설정하고 있었습니다. 그리고 무엇보다 iOS 웹브라우저 외에서는 정상 작동하고 있었습니다.

```js
setCookie(cname, cvalue, expires, domain, path) {
  var d = new Date()
  d.setTime(d.getTime() + expires * 24 * 60 * 60 * 1000)
  var expires = 'expires=' + d.toUTCString()

  var cookie = cname + '=' + cvalue + ';'
  if (expires != null) {
    cookie += ' expires=' + expires + ';'
  }
  if (domain != null) {
    cookie += ' domain=' + domain + ';'
  }
  if (path != null) {
    cookie += ' path=' + path + ';'
  }
  document.cookie = cookie
}
```

그래서 `혹시 iOS 브라우저들에서 사용하고 있는 iOS WebKit의 버그인가?`라는 생각을 하였습니다. 
관련된 내용을 열심히 구글링해도 딱히 관련된 내용은 찾을 수 없었기 때문에 `혹시 내가 처음으로 발견한 버그인가?!?`라는 설레발과 함께 `iOS 상황에서 쿠키 도메인이 jungbin.kim이 아닌 dev-test.jungbin.kim 과 같은 sub-domain까지 자동으로 넣어짐.` 이라는 결론을 내렸습니다.

### 어? 여기선 잘되는데요?
내가 처음 발견한 것인지도 모르는 버그에 대해서 (약간은 신나서..) 'iOS에서는 이런 현상이 있는 것 같다~' 라고 동료 분께 공유 드리니 같은 포맷의 언어 쿠키를 사용하는 서비스를 확인해보는게 좋을 것 같다는 피드백을 받았습니다.

그 서비스는 `Vue Cookie`라는 라이브러리를 사용하고 있었고, 놀랍게도 콘솔에서도 해당 라이브러리를 이용하여 쿠키를 설정하면 정상적으로 도메인이 `jungbin.kim`으로 들어갔습니다.

이때까지도 저는 '`Vue Cookie` 라이브러리가 iOS일 경우에는 다른 방법으로 넣는구나'라고 생각하고 있었습니다. 어떤 방법으로 해결했는지 궁금해져서 [Vue cookie](https://github.com/alfhen/vue-cookie)의 소스 코드를 살펴 보았습니다.
- Vue cookie의 쿠키 컨트롤 로직은 [tiny-cookie](https://github.com/Alex1990/tiny-cookie)를 사용합니다. Vue cookie는 tiny-cookie를 Vue에서 플러그인 형태로 사용할 수 있게 해주는 wrapper 역할입니다.

[tiny-cookie의 setCookie 로직](https://github.com/Alex1990/tiny-cookie/blob/master/src/index.js#L52)을 보니 크게 다른 방법을 사용하고 있지 않았습니다.

## 왜?!? iOS에서만...
약간의 멘붕을 겪고, 콘솔에서 사용하고 있는 setCookie를 살펴보았습니다. 

그제서야 눈에 들어온 것은 `expires`!

만료 시간에 대한 옵션을 넣을 때 key 인(`expires=`)이 중복해서 들어갔던 것이었습니다.

```js
  var expires = 'expires=' + d.toUTCString()

  var cookie = cname + '=' + cvalue + ';'
  if (expires != null) {
    cookie += ' expires=' + expires + ';'
  }
```

## 결말 - iOS 웹 브라우저의 쿠키 설정 시 특이사항
iOS 웹 브라우저의 쿠키 설정 시, **중간에 잘못 넣은 옵션값이 있다면 그 뒤에 넣은 값 모두 무시되고 기본값으로** 들어갑니다.(마치 for-loop가 돌다가 중간에 오류나서 그 뒤 순서가 제대로 돌지 못한 것 같은...)

아래 쿠키 테스트는 몇가지 조건으로 실험을 해본 것입니다. 이 테스트 결과를 보면 확실히 Mac Chrome은 어떤식으로 값을 넣어도 제대로 들어가는 무시무시한 결과를 보여주고, iOS 사파리는 뭔가.. 좀 특이합니다. (특히 test3, 4 속성값을 중복해서 넣어봤는데 이건 값은 제대로 들어가는데 그뒤에 오는 것은 무시됩니다.)

앞에서 언급한 보이지 않는 고릴라 실험에서는 패스의 수를 세다가 중간에 고릴라가 지나가도 눈치를 못챌수 있다는 것을 보여줍니다. 저도 크롬에서 되고 모바일 사파리에서는 안된 현상만 보다가 실제 실행 함수 로직을 자세히 보지 못한 실수가 있었습니다. 

웹이 플랫폼 상관없이 단일 개발로 다양한 플랫폼 대응을 할 수 있다는 건 분명 장점입니다. 하지만, 브라우저 벤더마다 또는 디바이스 별로 구현 방식이 다를 수 있고, 특정 브라우저 벤더에서만 제공해주는 API가 존재하기도 합니다. 그래서 사소한 차이가 발생할 수 있으며, 위의 문제와 같이 서로 다른 쿠키 파싱 방법을 가지기도 하는 것 같습니다. 


## 부록 - 쿠키 테스트
dev-test.jungbin.kim 사이트에서 실험

테스트1: 
* 조건: 
    * key= 를 중복
    * 중복된 속성의 위치를 domain 앞으로 보냄
* 입력값: `document.cookie = "userLang=ko_KR; expires=expires=Tue, 14 Sep 2027 04:33:51 GMT; domain=jungbin.kim;"`
* iOS 사파리 결과값: 
  * key가 중복된 속성인 expires은 값이 기본값이 들어갔으며, 잘못된 값 뒤에 있는 domain 속성 또한 기본값인 자기 자신의 도메인이 들어간 것을 볼 수 있다. 
  * ![test1-ios-safari.png](/img/posts/2019-06-23-test1-ios-safari.png)
* Mac Chrome 결과값: 
  * key가 중복되도 값이 정상으로 들어감
  * ![test1-mac-chrome.png](/img/posts/2019-06-23-test1-mac-chrome.png)

테스트2: 
* 조건: 
    * key= 를 중복
    * 중복된 속성의 위치를 domain 뒤로 보냄
* 입력값: `document.cookie = "userLang=ko_KR; domain=jungbin.kim; expires=expires=Tue, 14 Sep 2027 04:33:51 GMT;"`
* iOS 사파리 결과값: 
  * 테스트1과 다르게 domain 값이 정상적으로 들어갔다.
  * ![test2-ios-safari.png](/img/posts/2019-06-23-test2-ios-safari.png)
* Mac Chrome 결과값: 테스트1과 같다.

테스트3: 
* 조건:
    * =value 를 중복
    * 중복된 속성의 위치를 domain 앞으로 보냄
* 입력값: `document.cookie = "userLang=ko_KR; expires=Tue, 14 Sep 2027 04:33:51 GMT=Tue, 14 Sep 2027 04:33:51 GMT; domain=jungbin.kim;"`
* iOS 사파리 결과값: 
  * 값이 중복된 속성인 expires는 제대로 들어갔지만, 그 뒤에 위치한 domain 속성은 제대로 들어가지 않았다.
  * ![test3-ios-safari.png](/img/posts/2019-06-23-test3-ios-safari.png)
* Mac Chrome 결과값: 테스트1과 같다.

테스트4:
* 조건: 
    * =value 를 중복
    * 중복된 속성의 위치를 domain 뒤로 보냄
* 입력값: `document.cookie = "userLang=ko_KR; domain=jungbin.kim; expires=Tue, 14 Sep 2027 04:33:51 GMT=Tue, 14 Sep 2027 04:33:51 GMT;"`
* iOS 사파리 결과값: 
  * 값이 중복된 속성인 expires는 제대로 들어갔다. 
  * ![test4-ios-safari.png](/img/posts/2019-06-23-test4-ios-safari.png)
* Mac Chrome 결과값: 테스트1과 같다.