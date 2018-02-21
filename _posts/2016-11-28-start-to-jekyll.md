---
layout: post
title:  "Jekyll로 블로그 시작하기 위한 준비"
date:   2016-11-28 19:36:07 +0900
categories: [Jekyll]
tags: [Jekyll, Ruby, Github, GithubPage, Blog]
---

Jekyll로 블로그를 시작해보기 위해 설치하는 동안 만난 에러들과 설치 방법들

## Errors

### gem install File Permission Error

```bash
$ gem install jekyll
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.0.0 directory.
```

파일 permission 에러를 만나 관리자 권한을 사용하여 해결해보려고 함.

```bash
$ sudo gem install jekyll
Password:
ERROR:  While executing gem ... (Errno::EPERM)
    Operation not permitted - /usr/bin/kramdown
```

해결이 안 되었을 뿐만 아니라, sudo로 하는 것을 추천하지 않는다고 함.

문제가 생겨나는 원인은 Mac OS의 시스템 ruby가 설치되어 있는 폴더에 sudo 권한으로도 안되는 lock이 걸려 있기 때문으로 파악됨. ([엘케피탄 이후 도입된 rootless](http://macnews.tistory.com/3408))

따라서, 해결방법으로 rootless로 보호되고 있지 않은 곳에서 ruby, gem등을 관리하면 됨.

다양한 Ruby 버전을 사용할 수 있도록 관리해주는 rvm, rbenv 중에서 [rbenv](https://github.com/rbenv/rbenv)를 사용하기로 함.

homebrew로 설치하는 방법은 다음과 같음. [참고](https://github.com/rbenv/rbenv#homebrew-on-mac-os-x)

```bash
$ brew update
$ brew install rbenv
$ rbenv init
# Load rbenv automatically by appending
# the following to ~/.bash_profile:

eval "$(rbenv init -)"
```

Rbenv init의 결과로 나온 것을 참고하여 ~/.bash_profile에 `eval "$(rbenv init -)"`을 넣어주고,
수정된 bash_profile을 적용하기 위해 둘 중에 하나를 함.

- terminal을 껏다가 킴
- `$ source ~/.bash_profile`

그리고, `$ gem env home` 을 하면 `{user}/.rbenv/versions/2.3.0/lib/ruby/gems/2.3.0` 경로에 ruby가 설치된 것을 알 수 있음.

- 최근 포맷 후 재설치하는 과정에서, 위의 과정을 진행 할 때 여전히 작동을 안하며, `$ gem env home`가 원래 경로에서 변경되지 않은 것을 확인 (edit 2017.09.09)

    계속 에러가 나는 이유는 global ruby가 바뀌지 않아서였음. 
    [rbenv github command](https://github.com/rbenv/rbenv#command-reference)를 참고하여 다음 두가지 방법들을 적용해봄 (1, 2는 순서 아님)  
    ```bash
    // 1. Change global ruby version
    $ rbenv global {ruby version}
    
    // 2. Change local projcet ruby version by using rbenv 
    $ cd {local project}
    $ rbenv local 2.4.1
    ```

## Install dependencies
Gem dependencies를 설치해주는데 필요한 bundler를 설치 [참고](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/#requirements)

```bash
$ gem install bundler
```

설정한 뒤에 git clone 한 곳에 있는 위치에 가서 dependencies 설치 해줌 [참고](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/#step-2-install-jekyll-using-bundler)

```bash
$ cd {blog/project/path}
$ bundle install
```

## Test Local
로컬에서 jekyll 서버 돌리기 디폴트 포트 4000

```bash
$ jekyll serve --draft
```