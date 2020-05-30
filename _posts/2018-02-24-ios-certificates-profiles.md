---
layout: post
title: iOS App개발을 위한 Certificates와 Provisioning profile
date: 2018-02-24 14:08:54 +0900
published: true
comments: true
categories: [iOS]
tags: [iOS, Deploy]
type: note
---

iOS App 개발을 하기위해서는 Developer 등록과 함께 Certificates와 Provisioning profile이 필요함.
Certificates는 말 그대로 인증서. 이 인증서를 가지고 Provisioning profile을 만듬.
만약에 누군가 certificates를 만들어주고 provisioning profile을 만들어 주면,
(외주일 경우 클라이언트의 Apple developer 계정으로 생성) 
만든 provisioning profile을 다운 받아서 수동으로 xcode에 import.

자체 프로젝트로 회사 Apple developer 계정으로 진행할 경우, xcode에 로그인하면 자동으로 왠만큼 진행됨(xcode automatic 옵션 사용).
Apple developer 사이트에서 app id(번들)가 등록되어 있다면 automatic옵션을 클릭하면 certificate도 자동으로 만들어진다.

- [certificates 설명](https://jongampark.wordpress.com/2012/09/29/%EB%8B%A4%EC%8B%9C-%EB%B3%B4%EB%8A%94-ios-%EA%B0%9C%EB%B0%9C%EC%9D%84-%EC%9C%84%ED%95%9C-%EC%9D%B8%EC%A6%9D-%EA%B3%BC%EC%A0%95/)