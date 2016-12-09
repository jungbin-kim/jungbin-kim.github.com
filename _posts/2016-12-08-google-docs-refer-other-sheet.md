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

# 요구사항
- 공유 및 접근 가능성이 높아야함
- 시트B에는 현재까지 사용된 금액, 용도, 사용내역들이 존재
- 시트A에는 시트B의 데이터들을 사용하여 용도에 따라 정리된 형태로 보려고 함

# 접근 방법
- 구글 스프레드 시트를 사용
- 요구 사항을 만족하기 위해서는 조건에 맞는 시트B의 데이터들을 시트A에서 사용할 수 있어야 함

    예시:

    1. 시트B에는 고유값(id)과 매칭되는 데이터들이 무질서하게 존재함 (시트B는 일종의 id에 매칭되는 title을 갖고 있는 매핑 테이블 역할을 함)

        | id | title |
        | --- | --- |
        | 3 | title3 |
        | 2 | title2 |
        | 4 | title4 |
        | 1 | title1 |
        |   |       |

    2. 시트 A에는 id 값들과 description이 존재

        | id | description |
        | --- | :---: |
        | 1 | desc1 |
        | 2 | desc2 |
        | 3 | desc3 |
        | 4 | desc4 |
        |   |       |

    3. 시트 A에 시트 B를 참고하여 id에 매핑되는 title 데이터를 넣어야함 (여기서는 id가 조건이 됨)

        | id | description | id에 따른 title |
        | --- | :---: | :-------------: |
        | 1 | desc1 | title1 |
        | 2 | desc2 | title2 |
        | 3 | desc3 | title3 |
        | 4 | desc4 | title4 |
        |   |       |        |

# 구현
여기서 구현은 두 가지 종류의 함수를 사용하여봄.

## VLOOKUP
먼저 [VLOOKUP](https://support.google.com/docs/answer/3093318?hl=ko) 함수를 사용해서 다른 시트의 값을 참조.

### **사용법**

일단 잘 사용하였으나, 자유도가 떨어진다고 느낌.
예를 들면, `{찾고 싶은 id 셀 위치}`에 존재하는 값만을 `{검색범위}`에서 검색하여 `{범위 내 반환해야할 열의 순서}`에 존재하는 값을 반환함.
요구사항을 만족시키기 위해서는 여러가지 조건에 따라 필터링이 가능해야함. (ex. 특정 용도에 사용된 금액만을 선택한다던지)
또한, VLOOKUP 함수 사용법을 이해하기 어려웠음.

예시:

```
VLOOKUP({찾고 싶은 id 셀 위치},{검색범위: 시트B!$B$1:$C$534}, {범위 내 반환해야할 열의 순서})
```


## QUERY

### **사용법**
구글 문서편집기 고객센터 내 [QUERY](https://support.google.com/docs/answer/3093343?hl=ko)에 대한 정보를 보면 사용법을 알 수 있음.
SQL문에 익숙한 사람이라면 [query에 대한 API 문서](https://developers.google.com/chart/interactive/docs/querylanguage)를 참고하여 사용하는 것이 더 편한 것 같음.

예시:

```
IF(ISNA(QUERY('시트B'!A2:D, "select SUM(D) where A is not null and B = {'조건'} label sum(D) ''")), 0, QUERY('시트B'!A2:D, "select SUM(D) where A is not null and B = {'조건'} label sum(D) ''"))
```

### **기타**
- IF함수와 ISNA 사용 이유

    QUERY 내부 SQL 문을 실행하였을 때, 조건을 만족 시키는 결과가 아무것도 없을 경우, 위의 예에서는 select SUM(D) 값이 없을 경우 #N/A 가 출력됨.
    따라서 #N/A를 0으로 대체할 방법을 `google spread sheet #n/a remove` 으로 구글링.
    여러 방법이 검색되었지만, 가장 직관적인 것은 IF 함수와  사용하여 #N/A를 리턴하면 0을 아니면 같은 QUERY 함수를 사용하여 값을 리턴하게 함.

