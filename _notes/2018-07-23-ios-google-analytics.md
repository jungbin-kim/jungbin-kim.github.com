---
layout: post
title: Google Analytics on iOS
date: 2018-07-23 20:47:16 +0900
published: true
comments: true
categories: [iOS]
tags: [iOS]
---

## iOS App 에 Google Analytics 라이브러리 연동 
(Swift 3.2 / Xcode 9 초반) 코코아팟으로만 라이브러리 임포트를 했을 경우, import가 안되는 현상이 있음. 
Google Analytics 라이브러리 임포트하는게 제일 어려움.

다음과 같이 해결.
- pod file 에 `pod 'GoogleAnalytics'`를 추가
- 터미널의 프로젝트 루트 패스에서 `pod install`로 라이브러리 다운로드
- pod 라이브러리들이 있는 경로의 `libGoogleAnalytics.a` 파일과 header 파일들을 복사해서 프로젝트 폴더 내로 복사 이동 
    + `Linked Frameworks and Libraries` 에 `libGoogleAnalytics.a`를 포함. 
    + header 파일 중 필요한 목록을 bridge header에 import 해줌.
    
(주의) 이렇게 하면 실제로 `pod`로 다운받은 라이브러리는 복사하기 위해서만 사용됨.

### 참고 자료
- [GA 이벤트 관련 샘플 코드](https://github.com/googlesamples/google-services/blob/master/ios/analytics/AnalyticsExampleSwift/PatternTabBarController.swift) 
- [How to use Google Analytics for iOS via cocoapods](https://stackoverflow.com/questions/41992697/how-to-use-google-analytics-for-ios-via-cocoapods/47091321/) on Stack overflow
- [Use of unresolved identifier GGLContext and GAI](https://stackoverflow.com/questions/37241346/use-of-unresolved-identifier-gglcontext-and-gai) on Stack overflow
