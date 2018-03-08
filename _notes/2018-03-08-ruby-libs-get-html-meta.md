---
layout: post
title: Get HTML meta data by Ruby library
date: 2018-03-08 21:24:07 +0900
published: true
comments: true
categories: [Ruby]
tags: [Ruby, Script]
---

## HTML meta 데이터 가져오는 Ruby 스크립트 만들기
URL으로 HTML meta 데이터를 가져와 보여주는 Jekyll Plugin을 만들고 싶어서, 
해당 기능을 가지고 있는 Ruby 라이브러리들을 찾아봄.
URL을 입력값으로 meta 데이터를 객체로 매핑해서 반환해주는 것이 요구사항임. 

Plugin을 만들기 전 라이브러리들을 테스트해봄. 
우선, 아래와 같이 라이브러리를 다운로드하고, 실행.
```sh
# Install ruby gem
$ gem install {target gem name}

# Execute script 
$ ruby {target script name}.rb
``` 
스크립트들은 각 Github에 있는 예제를 참고하여 아래와 같이 작성.

### [open_graph_reader](https://github.com/jhass/open_graph_reader)
{% gist jungbin-kim/20d048ba0b168386a0962f2fe0aaf9f2 open_graph_reader.rb %}


### [ogp](https://github.com/jcouture/ogp)
{% gist jungbin-kim/20d048ba0b168386a0962f2fe0aaf9f2 ogp.rb %}


### [metainspector](https://github.com/jaimeiniesta/metainspector)
위의 두개는 제대로 데이터를 가져오는 사이트가 있고, 못 가져오는 사이트가 있었음. 
이 라이브러리는 테스트한 URL들은 정상적으로 가져옴.
{% gist jungbin-kim/20d048ba0b168386a0962f2fe0aaf9f2 @metainspector.rb %}