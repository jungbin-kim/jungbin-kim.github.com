---
layout: post
time: "Jan ~ Apr 2013"
title: "Disaster Alert Notification Service Using Windows Azure"
title_ko: "Windows Azure를 이용한 재난 알림 서비스"
skills: [C#, Azure]
description: ""
image: ""
categories: [project]
---

# UOS Multimedia Lab 학부연구생 Project 
- 주제: Windows Azure를 이용한 재난 알림 서비스
- 기간: 2013년 1월 7일 ~ 4월 15일
- C#, Azure를 이용한 window8 어플리케이션 개발

#### 데모 영상 (Demo video)
[![Video Label](http://img.youtube.com/vi/CyP6T1rnWso/0.jpg)](https://youtu.be/CyP6T1rnWso) 

#### 상세 내용[^1]
+ 개발 목적
    - 최근 세계 곳곳에서는 재난 발생이 증가하고 있으며, 재난의 규모 또한 커지고 있다. 
     이러한 재난을 예방하고 대응하기 위한 중요한 것 중 하나는 재난이 발생하였을 때 그 재난과 관계된 사람들에게 신속하게 전달하는 것이다. 
     신속한 재난 정보 전달을 통하여 재난에 의한 피해를 줄일 수 있다.
+ 재난 알림 서비스 설치 시 발생 이벤트
    <div style="text-align: center;">
        <img src="/img/portfolio/2013-04-15-install-application.jpg" alt="재난 알림 서비스 설치 시 발생 이벤트 그림" />
    </div>
    1. 윈도우8 어플리케이션에서 Windows Notification Server(이하 WNS)에게 사용자 채널 URI를 요청한다.
    2. WNS는 요청 받은 사용자 채널 URI를  어플리케이션에 보내준다.
    3. 어플리케이션에서 윈도우 애저 모바일 서비스의 데이터 테이블로 자신이 받은 채널 URI를 보내 저장한다.
    4. 어플리케이션의 설치가 끝난 후, 사용자는 자신이 재난 알림을 받고 싶은 지역을 선택한다. 선택된 정보는 윈도우 애저 모바일 서비스의 데이터 테이블에 저장, 읽기, 업데이트가 된다.
+ 재난 알림 서비스 작동 순서
    <div style="text-align: center;">
        <img src="/img/portfolio/2013-04-15-action-application.jpg" alt="재난 알림 서비스 작동 순서 그림" />
    </div>
    1. 윈도우 애저 모바일 서비스의 Scheduler에서 15분에 한번씩 미국 기상청 National Weather Service의 XML Feed Page에서 새로운 재난 정보가 있는 지 확인한다.
    2. 새로운 재난 정보가 있을 경우, 재난 발생 지역과 윈도우 애저 모바일 서비스 데이터 테이블에 저장되어있는 사용자의 선택 지역을 비교한다. 
    3. 재난 발생 지역과 사용자 선택지역이 일치하는 URI를 재난 정보와 함께 WNS로 보낸다.
    4. WNS에서 어플리케이션으로 재난 정보를 Push 알림을 해준다.
+ 개발 후기
    - Push 알림 기능을 사용하기 위해서는 모바일 디바이스의 각 플랫폼에 맞는 서버용 어플리케이션을 각각 개발하거나 통합 Push Notification Server를 만들어야 한다는 문제점이 존재한다. 
     하지만 윈도우 애저 모바일 서비스에서 제공하는 Push의 경우, 여러 플랫폼들(안드로이드, iOS, Windows)에 대해서 Push 알림 서비스를 제공해준다. 
     그래서 Windows 계열의 디바이스뿐만 아니라, 다양한 OS에 대한 Push 알림 서비스를 통합 관리하기 쉽게 된다.
    - 윈도우 애저 모바일 서비스에서 제공하는 Data 기능의 경우, 테이블에 1000개 이상의 데이터가 저장되어있을 경우, 조건에 맞는 데이터를 검색하는 속도가 무척 느려진다.
     실제로 윈도우8 어플리케이션에서 5000개 이상의 데이터가 저장된 데이터 테이블을 검색하는 명령을 했을 경우, 어플리케이션의 작동이 중지된다.
    - 개발한 어플리케이션은 사용자 채널 URI와 사용자가 선택한 지역 정보를 윈도우 애저 모바일 서비스 데이터 테이블에 저장한다.
     그래서 Disaster Subscriber를 사용하는 사람이 증가하면 윈도우 애저 모바일 서비스 데이터 테이블에 저장되는 정보 또한 증가할 것이다. 
     이에 따라 윈도우 애저에서 제공하여 주는 다른 저장소 서비스를 이용하는 것이 필요하다. 
     물론 다른 저장소 서버를 준비해서 사용할 수 있겠지만 이 경우에는 물리적 관리가 편하다는 장점이 사라진다.
    - 윈도우 애저 모바일 서비스에서 제공하는 기능인 Scheduler의 경우, 반복 실행이 되는 최소 시간은 15분이다. 
     그런데 재난 정보는 그 특성 상 신속한 전달이 필요하다. 
     그러기 위해서는 Scheduler의 반복 실행이 되는 시간을 5분 이하로 줄여야 한다. 
     하지만 윈도우 애저 모바일 서비스는 Scheduler를 자신이 원하는 형태로 바꿀 수 없다.
+ 보완할 점
    - Azure Cloud Service에서 윈도우 애저 모바일 서비스의 Scheduler 기능을 직접 구현함으로써 반복 실행 시간을 줄일 수 있을 것 (최소 반복 시간 15분 -> 초 단위).
    - Azure Service Bus의 Notification Hub를 사용하면, 대량 Push 알림 기능을 효율적으로 실행 가능.
    - Azure Data Storage는 윈도우 애저 모바일 서비스의 Data 기능을 대신해서 사용자들의 채널 URI와 사용자가 선택한 지역 정보들을 저장할 수 있다. 
     DBMS를 이용함으로 더 효율적인 데이터 관리가 가능하고 데이터의 검색 속도가 향상 가능.

---    
[^1]: 김정빈, 최성종. (2013). Windows Azure 를 이용한 재난 알림 서비스. 한국방송미디어공학회 학술발표대회 논문집, , 206-208.