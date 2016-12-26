---
layout: post
title: Web scraping with scala-#4
date: 2016-12-25 20:23:54 +0900
type: post
published: true
comments: true
categories: [programming, scala]
tags: [scala, web, scraping, crawling, crawler, 스칼라, 크롤러]
---

Continued [Web Scraping with Scala-#3](./programming/scala/2016/12/13/web-scraping-with-scala-3.html)


## Requirements

1. Wiki 페이지 안에 항목 페이지로 연결되는 Path 출력
    - 모든 항목 페이지는 id가 bodyContent 인 html element 안에 존재함
    - 항목 페이지의 Path 는 **/wiki/** 로 시작
    - 항목 페이지의 Path 는 세미콜론을 포함하지 않음
    ex) /wiki/Category: 와 같은 형태는 항목 페이지로 연결되지 않음.
2. 위 1번의 Wiki 페이지 안에 존재하는 항목 페이지로 연결하는 Path들의 리스트를 반환하는 getLinks 함수
3. 2번에서 만든 getLinks 함수를 호출해서 반환한 주소들 중 랜덤한 한 주소를 선택하여, getLinks 함수를 다시 호출하는 작업
    - 프로그램을 끝내거나 새 페이지에 항목 링크가 없을 때까지 반복

## Approach

### getLinks 함수

- getEither 함수

    [Web Scraping with Scala-#3](./programming/scala/2016/12/13/web-scraping-with-scala-3.html)
    에서는 Url에 존재하는 HTML 문서를 가져오는 동안의 예외들을 처리를 하기 위한 함수 **getEither**가 있었음.
    이 함수는 결과값을 출력하려 Unit 타입인 **println** 을 반환함.
    하지만, 이번에는 조금 변형하여 예외상황일 때 **Left**가 반환됨.

```scala
  def getEither[T, U](eitherBlock: Either[ErrorMessage, U])
                     (nextBlock: (U => Either[ErrorMessage, T])): Either[ErrorMessage, T] = eitherBlock match {
    case Left(e) => Left(e)
    case Right(doc) => nextBlock(doc)
  }
```

- getOpt 함수

    그리고, 가져온 HTML 문서를 파싱하여 원하는 데이터를 추출할 때 발생할 수 있는 예외들을 처리하기 위해서 **getOpt**를 만듬.
    입력 파라메터인 error는 optBlock을 실행해서 예외가 발생하기 전까지는 평가되지 않아도 됨.
    예외가 발생하면 Left를 반환.

```scala
  def getOpt[T, U](optBlock: Option[T], error: => ErrorMessage)
                  (nextBlock: T => Either[ErrorMessage, U]): Either[ErrorMessage, U] = optBlock match {
    case Some(e) => nextBlock(e)
    case _ => Left(error)
  }
```

- getLinks 함수

    Wiki 페이지 안에 존재하는 항목 페이지로 연결하는 Path들의 리스트를 반환하는 getLinks 함수를 작성.
    getEither와 getOpt을 사용하여 예외처리를 함.

```scala
  def getLinks( url: String ): Either[ErrorMessage, List[String]] = getEither( browser.getDocumentFromUrl( url ) ){ doc =>
    lazy val NotSelectedElement = ErrorMessage(0, "Not Selected Element", url)
    getOpt(doc >?> element("#bodyContent"), NotSelectedElement) { r =>
      Right(
        ( r >> elementList("a") ).filter(_.attr("href").matches("^(/wiki/)((?!:).)*$")).map(_.attr("href"))
      )
    }
  }
```

### loopGetLinks 함수

getLinks 함수를 호출해서 반환한 주소들 중 랜덤한 한 주소를 선택하여, getLinks 함수를 다시 호출하는 작업을 하기 위해서 다음을 사용함.

- [Scala Random](http://stackoverflow.com/questions/5051574/how-to-choose-a-random-element-from-an-array-in-scala)
- scala tail recursive annotation **@tailrec** [참고](http://stackoverflow.com/questions/3114142/what-is-the-scala-annotation-to-ensure-a-tail-recursive-function-is-optimized)

프로그램을 끝내거나 새 페이지에 항목 링크가 없을 때까지 반복

```scala
  @tailrec
  def loopGetLinks(targetUrl: String ): Either[ErrorMessage, List[String]] = getLinks( targetUrl ) match {
    case Left(l) => Left(l) //예외처리
    case Right(r) if r.isEmpty =>
        Left( ErrorMessage(0, "Empty Links", targetUrl) ) //Wiki 페이지 안에 존재하는 항목 페이지들의 Path 리스트들이 없을 경우
    case Right(r) =>
      val nextUrl =  "http://en.wikipedia.org" + Random.shuffle(r).head
      println(s"Next Url: $nextUrl") //Path 리스트 중 랜덤한 하나 출력
      loopGetLinks( nextUrl )
  }
```



