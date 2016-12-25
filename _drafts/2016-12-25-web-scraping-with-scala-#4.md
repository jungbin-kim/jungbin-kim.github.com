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
Url에 존재하는 HTML 파일을 가져오기 
[Web Scraping with Scala-#3](./programming/scala/2016/12/13/web-scraping-with-scala-3.html)
에서 제시하였던 getEither 함수를 조금 변형함.

```scala
  def getEither[T, U](eitherBlock: Either[ErrorMessage, U])
                     (nextBlock: (U => Either[ErrorMessage, T])): Either[ErrorMessage, T] = eitherBlock match {
    case Left(e) => Left(e)
    case Right(doc) => nextBlock(doc)
  }

  def getOpt[T, U](optBlock: Option[T], error: => ErrorMessage)
                  (nextBlock: T => Either[ErrorMessage, U]): Either[ErrorMessage, U] = optBlock match {
    case Some(e) => nextBlock(e)
    case _ => Left(error)
  }

  def getLinks( url: String ): Either[ErrorMessage, List[String]] = getEither( browser.getDocumentFromUrl( url ) ){ doc =>
    lazy val NotSelectedElement = ErrorMessage(0, "Not Selected Element", url)
    getOpt(doc >?> element("#bodyContent"), NotSelectedElement) { r =>
      Right(
        ( r >> elementList("a") ).filter(_.attr("href").matches("^(/wiki/)((?!:).)*$")).map(_.attr("href"))
      )
    }
  }
```

Scala Random 선택
http://stackoverflow.com/questions/5051574/how-to-choose-a-random-element-from-an-array-in-scala

scala recursive annotation
@tailrec