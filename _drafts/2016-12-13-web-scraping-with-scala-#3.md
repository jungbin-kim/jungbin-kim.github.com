---
layout: post
title: Web Scraping with Scala-#3
date: 2016-12-13 20:15:28 +0900
type: post
published: true
comments: true
categories: [programming, scala]
tags: [scala, web, scraping, crawling, crawler, 스칼라, 크롤러]
---

## Requirement
1. [Scala scraper](https://github.com/ruippeixotog/scala-scraper) 사용법

## Use
Web Scraping with Python[BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)(Python library for parsing html) 사용


### element
의 find()와 비슷

```scala
doc >> element(css_selector_string)
```
[CSS Selector Reference](http://www.w3schools.com/cssref/css_selectors.asp)
### elementList
web scaping with python의 findAll()

###

구현 방법 비교
[#2 Result](./programming/scala/2016/12/10/web-scraping-with-scala-2.html)에서 Url에 존재하는 자원을 가져오는 결과를 Either로 반환하게 만들었음.

- 가져오는데 에러가 발생한다면 Left에 error를 담아 반환.
- 아니면 Right에 결과값인 문서를 반환.

```Either[ErrorMessage, Document]```와 같은 형태로 반환하는데, 이 값을 처리하는 방법에 대한 고민을 함.

(1) Either를 처리하는 함수를 만들어 결과가 Right가 나올 때만 다음 함수를 실행하게 하는 방법

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