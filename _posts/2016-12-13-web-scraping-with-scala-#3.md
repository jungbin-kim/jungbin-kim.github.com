---
layout: post
title: Web Scraping with Scala-#3
date: 2016-12-13 20:15:28 +0900
published: true
comments: true
categories: [Scala]
tags: [Scala, Web crawler]
type: note
---

## Contents
1. [Scala scraper](https://github.com/ruippeixotog/scala-scraper) 함수
2. Scala Either 핸들링 방법 고찰


## Scala scraper 함수
Web Scraping with Python에서는 [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)(Python library for parsing html)을 사용
[Scala scraper](https://github.com/ruippeixotog/scala-scraper)에서는 [Jsoup](https://jsoup.org/)을 사용하기 때문에 일대일로 매핑할 수 없음
그래서 비슷한 기능을 하는 몇가지 함수에 대해서만 기록함.

### element
[BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)의 find()와 비슷

```scala
doc >> element(css_selector_string)
```
[CSS Selector Reference](http://www.w3schools.com/cssref/css_selectors.asp) 문서를 참고하여 element를 선택할 수 있음.

### elementList
[BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)의 findAll()와 비슷


## Scala Either 핸들링 방법 고찰
지난 게시글인 [Web Scraping with Scala-#2](./programming/scala/2016/12/10/web-scraping-with-scala-2.html)의 결과 부분에서 Url에 존재하는 자원을 가져오는 결과를 Either로 반환하게 만들었음.
```Either[ErrorMessage, Document]```와 같은 형태로 반환.
에러가 발생할 경우, Left(ErrorMessage)로 error 객체를 담아 반환히며, 정상적으로 결과값을 가져왔을 때에는 Right에 결과값인 문서를 반환함.
이 값을 처리하는 방법에 대한 고민을 함.

(1) Either를 처리하는 함수를 만들어 결과가 Right가 나올 때만 다음 함수를 실행하게 하는 방법. Left일 경우, error 프린트하고 종료.

```scala
//Get document or error message at url
val doc: Either[ErrorMessage, Document] = browser.getDocumentFromUrl( url )

// If 'eitherBlock' returns Left, then prints error
// else if it returns Right result, do nextBlock with result 'd'
def getEither[T,A](eitherBlock: Either[A, T])(nextBlock: (T => Unit)): Unit = eitherBlock match {
    case Left(e) => println(e)
    case Right(d) => nextBlock(d)
}

//Use-case 'getEither'
getEither(doc){
    d => println(d >> elementList("span.green"))
}
```


(2) 그냥 Either를 pattern matching으로 풀어 주는 방법

```scala
val nameList = doc match {
    case Left(e) => println(e)
    case Right(d) => d >> elementList("span.green")
}
println(nameList)
```

## Result
스칼라에서는 예외처리 방법으로 Either, Option, try~catch 등의 방법을 사용하고 있음. 

Option이나 Either의 경우, 예외를 값으로 반환함으로 함수형 프로그래밍에서 중요하게 생각하는 참조 투명성을 유지 가능하게 함.

이것을 만들고자하는 프로그램 로직 안에서 어떻게 처리를 해야 효율적일지 고찰이 필요함.