---
layout: post
title: Web Scraping with Scala-#1
date: 2016-12-10 11:29:18 +0900
type: post
published: true
comments: true
categories: [programming, scala]
tags: [scala, web, scraping, crawling, crawler, 스칼라, 크롤러]
---

## Requirement
[파이썬으로 웹 크롤러 만들기(Web Scraping with Python)](http://www.hanbit.co.kr/store/books/look.php?p_code=B7159663510)
에서 파이썬 기본 라이브러리로만 웹 데이터를 string으로 받아오는 것에 대응하는 스칼라 스크립트 만들어보기

## Approach
1. [스칼라로 URL 접근방법](http://alvinalexander.com/scala/scala-how-to-download-url-contents-to-string-file)
에서 제시한 방법대로 진행하였을 때, **google.com**에서 아래와 같은 에러 발생

    <!--language: bash-->
    [error] (run-main-0) java.nio.charset.MalformedInputException: Input length = 1
    java.nio.charset.MalformedInputException: Input length = 1
    ...

2. [Using result from Scalas “fromURL” throws Exception](http://stackoverflow.com/questions/29987146/using-result-from-scalas-fromurl-throws-exception)
에서 encode/decode 문제라는 것을 파악. 
**google.com**과 **naver.com**을 테스트. 
**google.com**은 "ISO-8859-1"로 설정할 경우, 글씨가 깨져서 나오지 않음. 하지만 **naver.com**은 글씨가 깨져서 나옴
웹사이트들은 제각각의 양식으로 만들어서 올리기 때문에 자동으로 판별해서 적용할 수 있으면 좋겠다는 생각을 함.

3. [mixed encodings in Scala or Java](http://stackoverflow.com/questions/13625024/how-to-read-a-text-file-with-mixed-encodings-in-scala-or-java)
에서 다양한 encoding 경우에도 적용할 수 있는 방법을 찾음


## Result
- 스칼라 스크립트
getStringFromURL.scala 에 아래 내용 저장

```scala
import scala.io.Source
import java.nio.charset.CodingErrorAction
import scala.io.Codec

implicit val codec = Codec("UTF-8")
codec.onMalformedInput(CodingErrorAction.IGNORE)
codec.onUnmappableCharacter(CodingErrorAction.REPLACE)

val url = "http://www.naver.com" //"http://google.com"
val html = Source.fromURL(url)
val s = html.getLines.mkString("\n")
println(s)
```

- 스크립트 실행

```bash
$ cd {path/folder}
$ scala getStringFromURL.scala
```