---
layout: post
title: iOS Ad-hoc deploy
date: 2018-02-24 14:34:28 +0900
published: true
comments: true
categories: [iOS]
tags: [iOS, ad-hoc, Deploy]
---

## Archive
App을 빌드하는 것을 archive 라고 함.
xcode 최상단 top 메뉴바에서 `Product > Archive` 
Archive가 완료되면, 지금까지 빌드한 앱들의 히스토리를 볼 수 있는 창이 뜸.
이 창은 `Window > Organizer` 으로 이동 가능.

## ad-hoc 방식으로 테스트 앱 배포
1. `Archive`를 하기 전, Project General에서 version 기입 및 ad-hoc profile 적용 
1. `Organizer` 창에서 배포할 버전의 앱을 선택 
1. 오른쪽 정보창의 `Export...` 버튼 클릭
1. `Ad Hoc` 선택 후, 뜨는 창(무슨 역할인지 아직 잘 모르겠음)에서 `Next`
1. `App URL`은 https로 접근 가능한 웹 서버 내 ipa파일 url path, 나머지 `Image URL`들은 아무 URL 입력.

참고: 
- http://blog.lonelie.kr/57
- http://jiwoochoi.tistory.com/103


