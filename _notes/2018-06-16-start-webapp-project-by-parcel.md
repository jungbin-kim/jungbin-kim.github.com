---
layout: post
title: Start a web app project by parcel
date: 2018-06-16 16:55:42 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript, Parcel]
---

## parcel 로 웹 앱 프로젝트 시작해보기
webpack 보다 가볍게 웹앱을 돌릴 수 있는 빌드툴이라는 소개를 보고 테스트해봄.

```sh
# 새로운 프로젝트 폴더 만들고 이동
$ mkdir parcel
$ cd parcel/

# npm project 시작
$ npm init -y
Wrote to /Users/jungbin/Development/Front-End/Playgrounds/parcel/package.json:
{
  "name": "parcel",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}

# parcel 라이브러리 package.json에 삽입 및 설치
$ npm install parcel-bundler --save-dev
```

- parcel 프로젝트 시작점 설정. `package.json` scripts 항목에 `"start": "parcel ./src/index.html"` 추가

- 위에서 설정한 시작점에 연결되는 실제 폴더/파일을 생성. `src` 폴더 만든 후, `index.html`, `index.js` 파일 생성.
    + `index.html`내에는 `<script src="js/index.js"></script>`와 같이 `index.js`를 임포트. 
    + 테스트를 위해서 `index.js`는 `console.log("HELLO PARCEL");`로 간단하게 작성 

- 그리고, start script 실행
```sh
$ npm run start
```

### ES6 문법 사용을 위한 babel 추가
- babel 라이브러리 추가
```sh
$ npm install --save-dev babel-preset-es2015
```
- babel 라이브러리 추가한 뒤, `.babelrc` 파일을 수정
```json
{
  "presets": ["env"]
}
```

### 테스트 startkit GitHub Repository
{% reference https://github.com/jungbin-kim/parcel-test %} 


## 참고
- [Parcel 공식 홈페이지](https://parceljs.org/getting_started.html)
- [(번역) Everything you need to know about BabelJS](https://jaeyeophan.github.io/2017/05/16/Everything-about-babel/#Configuring)
