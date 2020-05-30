---
layout: post
title: Build error on netlify when added a jekyll-seo-tag plugin
date: 2019-08-16 22:36:00 +0900
published: true
comments: true
categories: [Service]
tags: [Jekyll, netlify]
type: note
---

## Netlify 빌드 실패 현상
`failed during stage 'building site': Build script returned non-zero exit code: 1` 

```
5:15:56 PM: Installing gem bundle
5:15:56 PM: /usr/bin/env: ruby_executable_hooks
5:15:56 PM: : No such file or directory
5:15:56 PM: Error during gem install
5:15:56 PM: failed during stage 'building site': Build script returned non-zero exit code: 1
5:15:56 PM: Error running command: Build script returned non-zero exit code: 1
5:15:56 PM: Failing build: Failed to build site
5:15:56 PM: Finished processing build request in 23.066898681s
```

위의 에러는 `gem 'jekyll-seo-tag'` 를 Gemfile에 추가하면서 발생하였다. 로컬에서 빌드할 때는 빌드가 잘 되었지만, netlify 에서 빌드 실패되었다. 그래서 빌드 서버에 문제라고 생각을 하고 다음과 같은 일들을 해보면서 테스트 해보았다.
- Jekyll 의 버전을 3.x -> 4.x 로 업데이트
- gem bundler 의 버전을 업데이트
- `gem 'jekyll-seo-tag', git: 'https://github.com/jekyll/jekyll-seo-tag', branch: 'master'` [jekyll-seo-tag 플러그인 github](https://github.com/jekyll/jekyll-seo-tag)에서 받아오도록 변경
- gem install 시 문제인것 같아, netlify setting의 Build command를 `bundle update --bundler && jekyll build` 및 여러 가지로 수정해보면서 테스트

하지만 **여전히 빌드 실패하였다.**

## 해결 방법
`settings` > `deploys` > `build-image-selection` 로 가면 빌드할 때 사용할 이미지를 선택할 수 있다. 예전부터 사용하다보니 `Ubuntu Trusty 14.04`로 선택되어있었는데, 이를 `Ubuntu Xenial 16.04`로 변경하니 빌드가 성공하였다.

- Ubuntu Trusty 14.04: Legacy build image for older sites
- **Ubuntu Xenial 16.04 (default)**: Current default build image for all new sites
