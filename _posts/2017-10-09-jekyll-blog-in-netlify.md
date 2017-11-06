---
layout: post
title: Move hosting service from Github pages to netlify
date: 2017-10-09 19:43:11 +0900
categories: [blog]
tags: [Jekyll, Ruby, Github, GitpubPage, netlify]
---

## Overview
지금까지 [Github pages](https://pages.github.com/)에서 블로그를 호스팅하였음.
하지만, Github pages는 jekyll theme와 plugin들에 대한 제한이 존재하여, 
custom plugin이나 theme 적용시, 배포 실패가 되는 경우가 빈번해짐.
그래서, 호스팅 서비스를 Github pages에서 벗어나려고 함. 
다른 서비스 중 netlify로 옮기게 되었고, 그에 관한 글.

## Case
github pages로 호스팅하고 있는 블로그에 minimal-mistakes-jekyll theme를 적용하고 github repository에 push.
하지만, 아래와 같은 메일이 오면서 배포에 실패함.
```
The page build completed successfully, but returned the following warning for the `master` branch:
You are attempting to use a Jekyll theme, "minimal-mistakes-jekyll", which is not supported by GitHub Pages. 
Please visit https://pages.github.com/themes/ for a list of supported themes.  
```

## Procedure
1. 위의 상황에서 배포 실패한 `master` branch와 [netlify](https://www.netlify.com/) 연동
    + 가입 및 `Create a new site` 버튼을 눌러 Git repository 연동
    + 연동된 branch가 자동으로 배포되고, 접근할 수 있는 주소가 발급됨 (예: random-generate-sub-domain.netlify.com)
    + 해당 프로젝트의 `setting` > `Domain management` > `Domains` > `Custom domain` 추가  

2. 도메인 서버 수정 <br />
도메인 서버(내 경우에는 AWS Route53)의 기존 Github pages에 연동된 CNAME key의 value를 위에서 발급된 접근 가능한 주소로 대체.
처음부터 시작한다면 도메인 서버의 CNAME을 새로 만들고, key에는 접근하기 원하는 도메인 주소를, value에는 발급 받은 주소를 넣어주면 됨.
    + key: 내 소유 도메인 내 접근 주소 (예: subdomain.mydomain.com)
    + value: redirect ip address 또는 발급된 접근 주소 (예: random-generate-sub-domain.netlify.com)

3. Github repository의 Github pages 설정 수정 <br />
    + Github repository `Setting` > `GitHub Pages` > `Custom domain` 삭제 (Delete automatically `CNAME` file in repository)

4. 기타 설정 사항 <br />
Github pages에서 배포 실패한 `master` branch와 [netlify](https://www.netlify.com/)를 연동.
하지만, `master` branch에 push 할 때마다 Github pages에서 배포 실패 메일이 수신됨. 
두가지 방법을 생각해봄.
    1. Github pages와 repository 연동 제거
    2. Github pages의 다른 branch (`gh-pages`)를 만들어 그 branch의 내용이 배포

    기존 호스팅 방법이 repository name을 user id로 한 personal page로 하고 있었기 때문에, 두가지 방법 모두 적용하기 힘들었음.
    1번 방법은 repository 이름을 바꿔야 했고, 2번은 [personal page는 다른 branch를 master 대신할 수 없음](https://stackoverflow.com/questions/39978856/unable-to-change-source-branch-in-github-pages).
    그래서, 다음과 같은 방법을 사용.
    + `master` branch는 충돌 나지 않았던 기존 theme로 유지 
    + github personal page url로 접근하는 사람들을 위해 블로그 이전 공지
    + 새로운 theme가 적용된 source는 다른 branch로 만들어 netlify와 연동
    + Github repository `Setting` >  `Branches` > `Default branch` > 새로운 branch를 주 branch로 설정  

## netlify
해당 서비스를 선택 이유는 다음과 같다.
+ [가격표](https://www.netlify.com/pricing/)를 보면 무료로 할 수 있는 범위가 넓음  
+ github repository와 연동된 [Continuous Deploy](http://searchitoperations.techtarget.com/definition/continuous-deployment)[^1]
+ HTTPS for custom domains
+ github과 연동할 수 있어 회원 가입 간편


---  
[^1]: Continuous deployment는 자동화된 테스트를 통과한 commit이 자동으로 제품 배포 버전에 반영되는 소프트웨어 출시를 위한 하나의 전략.  
      
