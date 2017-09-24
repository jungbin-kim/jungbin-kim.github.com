---
layout: post
title: Web Scraping with Scala-#2
date: 2016-12-12 20:01:11 +0900
type: post
published: true
comments: true
categories: [programming, scala]
tags: [scala, web, scraping, crawling, crawler, 스칼라, 크롤러]
---

Continued [Web Scraping with Scala-#1](./programming/scala/2016/12/10/web-scraping-with-scala-1.html)
## Requirement
1. [Scala scraper](https://github.com/ruippeixotog/scala-scraper)(A Scala library for scraping content from HTML pages) 사용
2. Get URL에 대한 Exception Case 처리

## Approach

### Import Library
라이브러리 import를 편하게 하기 위해서 sbt 프로젝트 생성. 만들어둔 [start-kit](https://github.com/jungbin-kim/scala-sbt-start-kit) 사용

```scala
//in build.sbt
libraryDependencies ++= Seq(
  "net.ruippeixotog" %% "scala-scraper" % "1.2.0"
)
```

### Use Scala Scraper
[Scala scraper](https://github.com/ruippeixotog/scala-scraper)에서는 [Jsoup](https://jsoup.org/)이라는 Java HTML parser library를 사용.

- JsoupBrowser의 GET Method 사용
- 하지만, 예외처리가 존재하지 않아 [Jsoup API 문서](https://jsoup.org/apidocs/)에서 Exception Case 확인
    + [HttpStatusException](https://jsoup.org/apidocs/org/jsoup/HttpStatusException.html): HTTP error fetching URL, Not Found Content
    + [SerializationException](https://jsoup.org/apidocs/org/jsoup/SerializationException.html): A SerializationException is raised whenever serialization of a DOM element fails.
    ([HTTP 상태코드 참고](http://docs.oracle.com/cloud/latest/marketingcs_gs/OMCAB/Developers/GettingStarted/API%20requests/http-status-codes.htm))
    + [UnsupportedMimeTypeException](https://jsoup.org/apidocs/org/jsoup/UnsupportedMimeTypeException.html): Signals that a HTTP response returned a mime type that is not supported.
    ([HTTP 상태코드 참고](http://stackoverflow.com/questions/11973813/http-status-code-for-unaccepted-content-type-in-request))
- Scala의 예외처리 방법을 사용
    + [try-catch](https://twitter.github.io/scala_school/ko/basics2.html#exception)로 에러 발생 감지
    + **Either** 함수를 사용하여 에러 발생시 리턴값 명시

### Extends JsoupBrowser
스칼라의 trait을 사용하여 JsoupBrowser 객체의 Custom 버전을 손쉽게 확장할 수 있음.

## Result
```scala
//in Main.scala sbt
import net.ruippeixotog.scalascraper.browser.JsoupBrowser
import net.ruippeixotog.scalascraper.model.Document

object Scraper2 extends App {

  trait CustomBrowser extends JsoupBrowser {
    case class ErrorMessage( statusCode: Int, message: String, url: String )

    val browser = JsoupBrowser()

    def getDocumentFromUrl( url: String ): Either[ErrorMessage, Document] = {
      try {
        Right(browser.get(url))
      } catch {
        case e: org.jsoup.HttpStatusException => Left(ErrorMessage(e.getStatusCode, e.getMessage, e.getUrl))
        case e: org.jsoup.SerializationException => Left(ErrorMessage(400, e.getMessage, url))
        case e: org.jsoup.UnsupportedMimeTypeException => Left(ErrorMessage(415, e.getMessage, e.getUrl))
      }
    }
  }
  object browser extends CustomBrowser

  val url = "http://jungbin.kim"
  val doc = browser.getDocumentFromUrl( url )

  println(doc)
}
```