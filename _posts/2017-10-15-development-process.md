---
layout: post
title: Thinking of software development process for small team 
date: 2017-10-15 10:30:00 +0900
type: post
published: true
comments: true
categories: [programming]
tags: [programming, development process]
---

## Overview
Atlassian의 [jira](https://ko.atlassian.com/software/jira)와 [bitbucket](https://ko.atlassian.com/software/bitbucket)를 사용하였지만,
두 서비스를 별도로 사용하는 것과 별반 다를게 없어 좀 더 유기적으로 사용하여 이슈, 코드 관리를 하려함.
그러한 노력의 일환으로 각 jira 이슈 별로 bitbucket의 feature branch를 만들어주는 기능을 이용해봄.
jira에서 만들어진 이슈가 bitbucket의 branch와 매핑되어, 해당 이슈가 프로젝트 내에서 어떠한 변화를 가져왔는지 확인하기가 쉽다는 장점 존재. 
하지만, bitbucket 프로젝트 내에 feature branch가 너무 많이 생기는 문제가 존재함.
이러한 문제는 bitbucket에서 제공하는 `fork` 기능(github에서도 제공)을 통해 해결 가능함. 


## Procedure

1. `bitbucket`의 기존 git repository에서 개인 프로젝트로 fork 
    - fork 시, 자동 동기화 설정을 통한 original project 상태 공유

2. `jira` Issue 생성 후, feature branch 생성
    - `jira` Issue 내에는 연동된 `bitbucket`에 존재하는 프로젝트에 feature branch를 생성해주는 기능 존재
    - `bitbucket`의 feature branch는 1번에서 생성한 fork한 개인 프로젝트에서 생성

3. 개발하고 있는 `local` project에서의 설정 
    - 처음일 경우, fork한 repository를 새로운 remote repository로 추가하는 것이 필요     
    
    ```sh
    # (추가 형식) git remote add {remote name} {forked git project address at personal}
    $ git remote add jb https://jb@git.jungbin.kim/scm/~jb/example.git
    
    # 추가 확인
    $ git remote -v
    ``` 
    
    - 이슈에 따라 생성한 branch pull 받기 
    
    ```sh
    $ git pull jb feature/EX-100-my-issue
    ```
    
    
    - 개발을 위해 pull 받은 branch로 전환
    
    ```sh
    # git checkout new branch
    $ git checkout -b feature/EX-100-my-issue jb/feature/EX-100-my-issue
    ```

4. 개발을 진행한 후 개발 사항 master branch에 merge
    - branch merge는 현재 origin git repository에 해당 branch가 없어 그냥 `merge`보다는 `rebase` 방법으로 merge하는 것을 선택함
    
    ```sh
    $ git checkout feature/EX-100-my-issue
    
    # 아래 과정에서 master의 변경사항이 생겨 rebase 중 에러 발생 가능 
    $ git rebase master 
    
    $ git checkout master
    $ git merge feature/EX-100-my-issue
    ``` 

    - team에서 code review를 한다면 merge 전에  pull request를 보내면 됨 