---
layout: post
title: Apply sidebar at blog using Jekyll's Minimal Mistakes 
date: 2018-02-22 15:21:25 +0900
published: true
comments: true
categories: [Blog]
tags: [Jekyll]
type: note
---

Jekyll 블로그에서 카테고리 별로 이동할 수 있는 왼쪽 사이드바를 추가하고 싶었음. 
[Minimal mistake](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/)을 사용하고 있기 때문에
아래 링크를 통해 사이드바를 추가하고,  
- [Custom sidebar navigation menu](https://mmistakes.github.io/minimal-mistakes/docs/layouts/#custom-sidebar-navigation-menu)

모든 post를 Category별로 모아둔 페이지(category-archive)를 추가하여,
- [Jekyll 블로그 테마 적용하기](https://junhobaik.github.io/jekyll-apply-theme/) 내 `Navigation 설정` 참고

사이드바 메뉴를 눌렀을 때, category-archive 페이지에 해당 카테고리로 이동하도록 함.

- (단점) 왼쪽 사이드바의 타이틀과 링크들을 수동으로 수정해야함
- category-archive 페이지 내에서의 이동이 아닌, 카테고리 별로 모아두는 별도의 페이지를 자동으로 만들어주고 싶었음.
