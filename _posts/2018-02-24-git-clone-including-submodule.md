---
layout: post
title: How to clone submodule on git project
date: 2018-02-24 12:20:08 +0900
published: true
comments: true
categories: [Git]
tags: [Git, Programming]
type: note
---

인계 받은 프로젝트 내 git submodule이 포함되어 있었음.
일단 `$ git clone` 후, submodule을 실행하려니, 
submodule의 repository 주소가 인계자 아이디가 포함된 절대 주소 값으로 표현되어 있었음.
(ex. https://{다른 사람 id}@repository.git.io/scm/project/path)
그래서 git submodule 주소를 처음 clone한 프로젝트의 상대주소로 바꿔줌.

다른 방법으로는 ssh로 접근할 수 있는 주소로 바꿔주는 방법이 있을 것 같음.

```sh
$ vi .gitmodules
# ==> Change repository

$ git submodule sync
$ git submodule update --init --recursive --remote
```

[참고: Changing remote repository for a git submodule](https://stackoverflow.com/a/43937092)