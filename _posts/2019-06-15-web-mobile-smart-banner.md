---
layout: post
title: Smart Banner to announce app on mobile web
date: 2019-06-15 15:47:00 +0900
published: true
comments: true
categories: [Web]
tags: [Mobile]
type: note
---

## 모바일 웹에서 앱을 알리는 방법
어떠한 서비스에서 모바일 웹과 동일한 기능이거나 더 나은 기능을 제공해줄 수 있는 모바일 앱이 있을 수 있다. 그러한 경우 사용자가 그 앱을 다운로드 받을 수 있도록 안내를 해줄 필요가 있다. iOS라면 App Store, 안드로이드라면 구글 플레이 스토어 URL 등으로 a 태그를 이용하여 연결하면 된다.

```html
<a href="https://play.google.com/store/apps/details?id=com.nhn.toast.console" >Play Store 다운로드</a>
<a href="https://apps.apple.com/app/id1454457828" >App Store 다운로드</a>
```

이렇게 설정하면 모바일에서 해당 링크를 누를 경우, 자동으로 스토어에서 열겠냐고 물어본다.

위의 방식의 경우, 앱 개발자가 직접 다운로드 관련된 UI를 만들어야한다. 아래는 iOS에서 지원해주는 Smart App Banner와 그외 기타 방법에 대해서 소개한다.

### iOS Safari
iOS 에서는 [Promoting Apps with Smart App Banners](https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariWebContent/PromotingAppswithAppBanners/PromotingAppswithAppBanners.html)라는 것을 제공해준다. html head의 정해진 형식의 meta 태그(아래 사용법 참고) 추가하면, 사파리 브라우저에서 접근한 모바일 웹 페이지의 경우 상단에 앱을 열거나 다운로드 할 수 있는 링크가 추가되서 나온다.

- Safari는 iOS 6 이상에서 Smart App Banner 기능을 제공.
- iOS의 경우, html 메타 태그로 지원
- 이 기능은 웹 사이트에서 App Store의 앱을 홍보하는 표준화된 방법을 제공.
- 시뮬레이터 사파리 앱에서는 제대로 나오지 않음.

사용법:
```html
<html>
  <head>
    <!-- content의 app-id 값만 필수, 나머지 값은 없어도 상관없다. -->
    <meta name="apple-itunes-app" content="app-id=myAppStoreID, affiliate-data=myAffiliateData, app-argument=myURL">
  </head>
  <body>
  
  </body>
</html>
```
* app-id: 앱스토어 원하는 앱 페이지 url 내 id 뒤에 붙는 9자리 숫자. 
  * ex. `https://apps.apple.com/app/id1454457828` 에서 1454457828 이 id 이다.
* affiliate-data: iTunes 제휴사 문자열이라고 되어 있는데, 제휴사를 특정할 수 있는 id 값인것 같다.
* app-argument: 앱에게 정보를 전달할 수 있는 인자값들. 이 인자값을 앱에서 받아서 특정 페이지로 이동한다던가 하는게 가능, deep link와 비슷.

### 안드로이드
안드로이드에서는 별도로 제공되는 가이드는 없다.

### 기타
JQuery Smart Banner나 기타 라이브러리(no JQuery)이 있지만 최근 업데이트는 없는 것 같다. 기타 라이브러리를 사용할 때 주의할 점은 iOS 메타 태그와 겹칠 수도 있다는 점이다.

## 결론 및 느낀점
위에서 조사된 것 중 선택해서 사용하면 편하긴 하지만 아래의 경우를 고려해야겠다.
- 배너의 위치가 상단으로 고정되며 디자인 수정의 여지가 없어진다.
  - 모바일 웹에서 사용성과 디자인을 고려해서 그에 맞는 위치에 노출하는 것으로 직접 개발하는 경우가 있다.
- 때로는 deep link 등을 이용해서 모바일 웹에서 앱의 원하는 페이지로 이동이나 다른 기능들을 실행해야하는 경우도 있다. 
  - 각 웹 페이지 별로 이동된 앱에서의 행동이 달라지는 것과 같은 요구사항이 복잡한 경우는 차라리 직접 개발하는 게 편하다.
- 직접 개발할 경우 모바일 웹에서 iOS랑 안드로이드를 직접 구분해야한다. [라이브러리 내 플랫폼 구분 로직](https://github.com/jasny/jquery.smartbanner/blob/master/jquery.smartbanner.js#L32)을 보면 보통은 user agent로 구분하는 것 같은데 생각보다 까다롭다.