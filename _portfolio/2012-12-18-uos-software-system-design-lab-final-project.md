---
layout: post
time: "2nd Semester 2012"
title: "Proposal for the system of criminal statistics by regions"
title_ko: "지역별 범죄 통계 시스템 제안"
skills: [MySQL, PHP, HTML]
description: ""
image: ""
categories: [project]
---

# 서울시립대 소프트웨어 시스템 설계 과목 최종 프로젝트 
- 주제: 서울 지방 경찰청에서의 지역별 범죄 통계 시스템 제안
- 기간: 2012년 2학기
- MySQL, PHP, HTML

## 데모 영상 (Demo video)
<iframe width="640" height="360" src="https://www.youtube.com/embed/RwkKbB1LO8E?ecver=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## 상세 내용
+ 개발 목적 
    - MySQL와 PHP를 이용한 [Data WareHouse](https://ko.wikipedia.org/wiki/%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%9B%A8%EC%96%B4%ED%95%98%EC%9A%B0%EC%8A%A4) 기반의 홈페이지를 구축하여 서울시민들에게 범죄통계 관련 정보 전달을 용의하게 하는 것
+ 기대효과
    - 범죄 가능 지역 회피
    - 위험지역 경찰 순찰 강화 및 위험지역 선정 용이
    - 범죄 피해로 인한 경제적 가치, 인명피해 방지
    - 범죄 발생과 그에 따른 요인을 분석함으로 좀 더 정확한 정책 및 대책 수립 가능
+ <details>
      <summary>요구사항 분석</summary>
      
      <p>
      - 홈페이지 방문자는 범죄에 관한 통계자료를 볼 수 있고 그것을 이용해 범죄와 관련된 사항 조사해볼 수 있다.
      </p><p>
      - 범죄통계 데이터베이스에는 범죄에 관한 사항과 지역 정보, 가해자 정보, 피해자 정보, 범죄 유형 정보, 시간 정보, 관리자 정보를 저장한다. 각 지역 별로 범죄 유형과 날짜 별 범죄 발생현황을 알 수 있어야 한다. 
      </p><p>
      - 방문자가 범죄에 관한 통계자료를 지역별, 날짜 별, 범죄유형별, 피해자 유형별, 가해자 유형별로 볼 수 있게 만든다. 
      </p><p>
      - 사건은 사건번호, 범죄유형, 지역, 발생날짜, 발생 시간을 저장한다.
      </p><p>
      - 가해자 유형정보에는 주민등록번호, 사건번호, 성별, 나이, 학력, 직업, 혼인, 전과에 대한 정보가 있다. 주민등록번호는 가해자를 구분하기 위한 장치이다. 이 부분은 방문자에게 공개되지 않는다.
      </p><p>
      - 피해자 유형정보에는 주민등록번호, 사건번호, 성별, 나이, 학력, 직업, 혼인에 대한 정보가 있다. 주민등록번호는 피해자를 구분하기 위한 장치이다. 이 부분은 방문자에게 공개되지 않는다.
      </p><p>
      - 지역 정보에는 지역, 면적, 행정동 수, 경찰서(지구대) 수, 소방서 수, 인구 수, 인구 밀도, 외국인 수를 저장한다.
      </p><p>
      - 범죄 유형에는 범죄 분류 별 범죄 명칭을 저장한다
      </p><p>
      - 각 유형 카테고리 별로 사건의 수를 그래프로 표현하여 방문자가 정보를 손쉽게 해석할 수 있게 한다.
      </p><p>
      - 시간 정보에는 2012년 날짜(1월 1일~12월 31일), 분기, 주, 요일, 이벤트(월드컵, 대선 등) 등을 저장한다.
      </p><p>
      - 관리자 정보에는 관리자 아이디, 이름, 이메일, 비밀번호를 저장한다.
      </p><p>
      - 관리자는 사건과 피해자 정보, 가해자 정보를 등록할 수 있다.
      </p>
   </details>
+ 주요 개체집합 도출
    - 사건, 피해자, 가해자, 시간정보, 지역정보, 유형정보, 관리자
+ 도출한 개체집합이 포함하는 속성 정의
+ <details>
   <summary>관계집합 정의</summary>
          
    <p>
    존재1: 사건 속에 피해자가 존재한다.</p><p>
    존재2: 사건 속에 가해자가 존재한다.</p><p>
    존재3: 사건 속에는 날짜 정보가 존재한다.</p><p>
    존재4: 사건 속에는 범죄 유형이 존재한다.</p><p>
    존재5: 사건 속에는 지역 정보가 존재한다.</p><p>
    등록1: 관리자는 사건을 등록할 수 있다.</p><p>
    등록2: 관리자는 피해자 정보를 등록할 수 있다.</p><p>
    등록3: 관리자는 가해자 정보를 등록할 수 있다.
    </p>
   </details>

+ 개념적 설계
{% 
   include figure_with_caption.html 
   url='/img/portfolio/2012-12-18-conceptual-design.jpg'  
%}

+ 물리적 설계
{% 
   include figure_with_caption.html 
   url='/img/portfolio/2012-12-18-physical-design.png'  
%}


```sql
-- Crime Table 생성
CREATE TABLE `crime` (
  `crime_num` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(45) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  PRIMARY KEY (`crime_num`)
);

-- Attacker Table 생성
CREATE TABLE `attacker` (
  `a_register_num` varchar(15) NOT NULL,
  `crime_num` int(11) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `academic` varchar(10) DEFAULT NULL,
  `marriage` varchar(45) DEFAULT NULL,
  `crime_record` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`a_register_num`,`crime_num`),
  KEY `crime_num_idx` (`crime_num`),
  CONSTRAINT `crime_num` FOREIGN KEY (`crime_num`) REFERENCES `crime` (`crime_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Victim Table 생성
CREATE TABLE `victim` (
  `a_register_num` varchar(15) NOT NULL,
  `crime_num` int(11) NOT NULL,
  `gender` char(1) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `academic` varchar(10) DEFAULT NULL,
  `marriage` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`crime_num`,`a_register_num`),
  KEY `crime_num_idx` (`crime_num`),
  CONSTRAINT `crime_num2` FOREIGN KEY (`crime_num`) REFERENCES `crime` (`crime_num`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Location Dimension Table 생성
CREATE TABLE `location_dim` (
  `location` varchar(45) NOT NULL,
  `area` float DEFAULT NULL,
  `dong_num` int(11) DEFAULT NULL,
  `police_station_num` int(11) DEFAULT NULL,
  `fire_station_num` int(11) DEFAULT NULL,
  `people_num` int(40) DEFAULT NULL,
  `people_density` int(40) DEFAULT NULL,
  `foreigner_num` int(40) DEFAULT NULL,
  PRIMARY KEY (`location`)
);

-- Time Dimension Table 생성
CREATE TABLE `time` (
  `time` date NOT NULL,
  `quarter` int(11) DEFAULT NULL,
  `week` int(11) DEFAULT NULL,
  `dayofweek` char(5) DEFAULT NULL,
  `event` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`time`)
);

-- Type Dimension Table 생성
CREATE TABLE `type_dim` (
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`type`)
);

-- user Table 생성(관리자)
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
); 
```