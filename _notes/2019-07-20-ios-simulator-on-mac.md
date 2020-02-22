---
layout: post
title: Debug a web app using Simulator & Safari on Mac
date: 2019-07-20 19:08:00 +0900
published: true
comments: true
categories: [Tool]
tags: [Web, iOS, Safari, Mac]
---

## Mac에서 iOS Simulator와 Safari를 사용한 웹앱 디버깅
모바일 웹앱 개발을 하면 모바일 사파리에서 디버깅을 해야할 때가 있다. 
모바일 사파리는 다른 브라우저는 물론 맥 사파리와도 다른 동작을 보여줄 경우가 있기 때문이다.

실제 모바일 디바이스를 사용해서 하는 방법이 제일 정확하지만, 화면 크기를 다양하게 실행해봐야할 때와 같이 모바일 디바이스 기기들을 모두 확보하기 제한적인 경우도 있다.

이를 해결해보고자 Apple 계열 어플리케이션 개발 도구인 Xcode에는 Simulator라는 기능을 이용해본다. Simulator를 이용하면 가상의 iOS 디바이스가 Mac에서 구동된다. 
보통은 모바일 앱 개발할 때 사용하지만, Simulator로 구동된 디바이스에는 Safari 앱을 포함한 기본 앱들도 깔려있다. 그래서 설치되어있는 Safari 앱을 이용하면, 로컬에서 구동한 모바일 웹앱을 디버깅할 수 있다.

![2019-07-20-ios-similator.png](/img/posts/2019-07-20-ios-similator.png)

## Simulator 실행
준비사항:
- XCode 10 (이전 버전에도 지원했지만, 테스트한 버전이 10)

Simulator 실행:
- Xcode 실행 -> 상단 메뉴 Xcode -> Open Developer Tool -> Simulator
  - ![ios-simulator-where.png](/img/posts/2019-07-20-ios-simulator-where.png)
- Simulator 실행된 후 -> 상단 메뉴 Hardware -> Device
  - ![2019-07-20-ios-simulator-device-where.png](/img/posts/2019-07-20-ios-simulator-device-where.png)


## Mac Safari 설정
준비사항:
- Safari -> Preference -> Advanced -> Check `Show Develop menu in menu bar`

**(2020.02.22 업데이트)**

이제 Mac 사파리에서 Simulator 모바일 사파리 웹 페이지 디버깅이 안되는 것 같다.
대신, [`Safari Technology Preview`](https://developer.apple.com/safari/technology-preview/)라는 사파리 베타 버전을 설치하여 디버깅 할 수 있다.

사파리에서 `Develop > Get Safari Technology Preview` 메뉴로 다운로드 페이지로 들어갈 수 있고,

![](/img/posts/2020-02-22-ios-simulator-web-debug.jpg)

또는 brew로 `$ brew cask install safari-technology-preview` 로 설치 가능 하다.


## Debug web app
- Mac 로컬에서 웹앱 구동 ex. localhost:4443
- Simulator로 돌아가는 가상 디바이스의 Safari에서 로컬 웹앱 접근
- Mac Safari 상단 메뉴 -> Develop -> Simulator-{가상 디바이스}
  - ![2019-07-20-safari-debug.png](/img/posts/2019-07-20-safari-debug.png)

Safari의 개발자 도구가 나타나고, 이를 사용하여 디버깅!

## 기타
- Mac 크롬 브라우저 개발자 도구를 이용해서 모바일 사파리에 돌아가고 있는 웹앱 디버깅 방법도 있는 것 같다. 
  - 참고: [How to debug an issue in Chrome for iOS using remote debugging](http://jonsadka.com/blog/how-to-debug-a-chrome-specific-bug-on-ios-using-remote-debugging)
- 모바일 상황에서 크롬에서 돌아가고 있는 앱을 디버깅헤보고 싶었는데 아직까지 찾지 못하였다.
