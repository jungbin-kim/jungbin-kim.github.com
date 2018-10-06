---
layout: post
title: Swift3(PromiseKit)으로 Async 사용해보기
date: 2018-03-04 19:01:45 +0900
type: post
published: true
comments: true
categories: [Programming]
tags: [Swift3, Promise, Scala, JavaScript]
---

## Overview
Swift3 의 [Alamofire](https://github.com/Alamofire/Alamofire) 라이브러리를 사용하여 callback 함수로 API request를 구현.
하지만, callback 함수 부분이 가독성이 떨어지는 것 같아 코드를 리팩토링해보기로 결정.
`AngularJS`에서 defer 객체를 통한 Promise와 `Scala`의 Future, Promise 등과 같이 익숙한 형태를 찾아봄.
Swift에서 Promise 패턴을 사용할 수 있는 라이브러리인 [PromiseKit](https://github.com/mxcl/PromiseKit)과 
Alamofire을 확장한 [PromiseKit+Alamofire](https://github.com/PromiseKit/Alamofire-)을 발견하고 사용. 

## 비교를 위한 AngularJS 내 Promise, Scala의 Future

### AngularJS + defer
{% gist jungbin-kim/913aa9e85ef8c2510431b804bd186b38 AngularJS-defer.js %}

### Scala + Future
`def getList(productId: String): Future[Either[ErrorMessage, SomeResponseModel]]`에서는 
`ErrorMessage`라는 타입을 통해 실패에 대한 정보를 반환함. 
아래의 예에서는 `ErrorMessage`을 `String`으로 선언하였지만, Enum 이나 case class 등 다르게 선언하여 사용할 수도 있음.
    
{% gist jungbin-kim/913aa9e85ef8c2510431b804bd186b38 Scala-Future.scala %}


## Swift3 with PromiseKit
{% gist jungbin-kim/913aa9e85ef8c2510431b804bd186b38 Swift3-Alamofire-PromiseKit.swift %}

위와 같이 [PromiseKit](https://github.com/mxcl/PromiseKit), [PromiseKit+Alamofire](https://github.com/PromiseKit/Alamofire-)을 사용한 경우, 
실패에 대한 처리가 앞에서 나온 AngularJS와 비슷함. 
Promise 객체의 reject 함수(Promise의 callback 함수의 두번째 인자를 reject 으로 표현)를 사용하여, 실패에 대한 처리를 함. 
reject 함수는 Error 객체를 통해 실패에 대한 자세한 정보(ex. 코드 내 `MyErrors.Unknown` 과 같은 커스텀된 실패 정보)를 전달 가능. 

reject 함수가 호출되면, 
- Promise의 반환값을 처리하는 곳에서는 catch문이 실행. 
- catch 문 내에서 실패 정보에 따라 그에 맞는 행동을 정의.

`Promise<SomeResponseModel?>`를 반환하는 첫번째 `getProduct` 함수와 같이 해당 함수의 실행 실패를 반환하는 방법도 있음. 
하지만 실패에 대한 모든 경우가 `nil`로 표현되어, 실패했다는 사실을 알릴 수는 있어도 실패 이유와 같은 자세한 정보를 알릴 수 없음. 
실패에 대한 정보를 포함하고자 하기 위해서는 scala의 Either와 같은 객체를 만들어 전달할 수는 있음. 

### 실패에 대한 이유를 같이 전달하는 코드의 장점
- 유지보수나 협업을 할 때, 별도의 문서가 아닌 코드 상에서 함수 내 실패 가능성을 명시적으로 표현 할 수 있었음. 
- 좀 더 Pure Functional 형태로 Promise 객체 내 성공, 실패에 대한 정보를 반환할 수 있는 형태면 좋을 것 같음. 
이 경우 함수의 명세(이름, Input parameters, Return 타입 등)만 보고서 어떤 실패 가능성이 있는 함수인지 알 수 있음. 
그렇지 않은 경우, 그 함수를 쓰고 있는 catch 문을 봐야 어떤 실패 가능성이 있는 함수인지 알 수 있음. 

위와 같은 이유로 스칼라에서는 발생할 수 있는 오류에 대해서 try catch 보다는 Option, Either 객체를 사용한 값으로 매핑하는 것을 권장하고 있음.

## 참고
- [Chaining Async Requests in iOS](https://medium.com/@nrewik/chaining-async-requests-in-ios-b492ad9d9b4a)
- [Returning a Promise from PromiseKit/Alamofire Ask](https://stackoverflow.com/questions/40638631/returning-a-promise-from-promisekit-alamofire)
- [Swift 3 Error type](https://medium.com/@derrickho_28266/swift-3-error-type-ec86feab43e7)