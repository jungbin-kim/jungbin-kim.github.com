---
layout: post
title: 구글 스프레드 시트에서 다른 시트 참조하기 
date: 2016-12-08 09:37:37 +0900
type: post
published: true
comments: true
categories: [office]
tags: [tip, 구글스프레드시트, googlespreadsheet, excel, google, vlookup, query]
---

## 목적
- 구글 스프레드 시트를 사용하여 공유 및 접근 가능성 높음
- 시트B에는 현재까지 사용된 금액, 용도, 사용내역들이 존재
- 시트A에는 시트B 사용 용도에 따라 정리된 형태로 보려고 함.

## VLOOKUP
예전에 [VLOOKUP](https://support.google.com/docs/answer/3093318?hl=ko) 함수를 사용해서 다른 시트의 값을 참조해 본 적이 있음.
그때의 상황은 다음과 같았음.

- 시트B에는 고유값(id)을 가진 데이터들이 나열되어 있음. (시트B는 일종의 id와 title을 연결해주는 매핑 테이블 역할을 함)

| id| title |
| ------ | ----------- |
| 1 | title1 |
| 2 | title2 |
| 3 | title3 |
| 4 | title4 |


- 시트 A에는 id 값들과 description이 존재

id | description

- 시트 A에 시트 B를 참고하여 title 데이터를 넣음

Id | descriptoin | id에 따른 title

```
VLOOKUP({찾고 싶은 id 셀 위치},{검색범위: 시트B!$B$1:$C$534}, {범위 내 반환해야할 열의 순서})
```

일단 저 용도로는 잘 사용하였으나, VLOOKUP 함수 사용법을 이해하기 어려웠음.

## QUERY
구글 문서편집기 고객센터 내 [QUERY](https://support.google.com/docs/answer/3093343?hl=ko)에 대한 정보를 보면 사용법을 알 수 있음

예시

```
IF(ISNA(QUERY('시트B'!A2:D, "select SUM(D) where A is not null and B = {'조건'} label sum(D) ''")), 0, QUERY('시트B'!A2:D, "select SUM(D) where A is not null and B = {'조건'} label sum(D) ''"))
```

- IF함수와 ISNA 사용 이유

QUERY 내부 SQL 문을 실행하였을 때, 조건을 만족 시키는 결과가 아무것도 없을 경우, 위의 예에서는 select SUM(D) 값이 없을 경우 #N/A 가 출력됨.

따라서 #N/A를 0으로 대체할 방법을 `google spread sheet #n/a remove` 으로 구글링.

여러 방법이 검색되었지만, 가장 직관적인 것은 IF 함수와  사용하여 #N/A를 리턴하면 0을 아니면 같은 QUERY 함수를 사용하여 값을 리턴하게 함.
 
[query에 대한 API 참고](https://developers.google.com/chart/interactive/docs/querylanguage)
SQL문에 익숙한 사람이라면 이 함수가 차라리 사용하기는 더 편한 것 같음.
