---
layout: post
title: Set Java version manager (jenv)
date: 2018-04-28 19:09:22 +0900
published: true
comments: true
categories: [Java]
tags: [Version Management]
---

## 자바 버전 관리자(jenv) 설치
다양한 버전의 자바를 사용하기 위해서 버전 관리 패키지([jenv](http://www.jenv.be/))를 설치.
```sh
$ brew install jenv

# ~/.jenv/versions 디렉토리가 없으면 실패 할 수 있음
$ mkdir -p ~/.jenv/versions

# 자바 최신 버전 설치됨 (2018.04.28 기준 v10.0.1)
$ brew cask install java

# 설치하고자하는 java 버전 설치
$ brew cask install java8

# java home에 설치 되었는지 확인 
$ /usr/libexec/java_home -v 1.8
/Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home
# v10.0.1은 10으로 설치 확인
$ /usr/libexec/java_home -v 10
/Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home

# jenv에 자바 버전 추가 (v10도 같은 방법으로 추가)
$ jenv add /Library/Java/JavaVirtualMachines/jdk1.8.0_172.jdk/Contents/Home
oracle64-1.8.0.172 added
1.8.0.172 added
1.8 added
```

bash_profile에서 jenv이 java 버전 명령 설정
(아래 Error Handling의 `global로 자바 버전을 바꾸었는데, 자바 버전이 안 바뀌어 있음`의 결과)
```sh
$ echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(jenv init -)"' >> ~/.bash_profile

# 터미널에 bash_profile 변경사항 적용
$ source ~/.bash_profile
```

### Install OpenJDK
```sh
# openjdk 버전 찾아보기
$ brew search adoptopenjdk
==> Casks
adoptopenjdk                      adoptopenjdk11                    adoptopenjdk8 ✔
adoptopenjdk10                    adoptopenjdk11-openj9             adoptopenjdk9

# (Optional) adoptopenjdk를 찾을 수 없는 경우
$ brew tap AdoptOpenJDK/openjdk

# 원하는 버전 설치
$ brew cask install adoptopenjdk10
```

[What does brew tap mean?](https://stackoverflow.com/questions/34408147/what-does-brew-tap-mean):
> The tap command allows Homebrew to tap into another repository of formulae.

참고: [Installing OpenJDK Versions on Macs](https://dzone.com/articles/install-openjdk-versions-on-the-mac)


## Use

```sh
# 사용 가능한 자바 버전들 보기
$ jenv versions
  system
  1.8
* 1.8.0.172 (set by /Users/jb/.jenv/version)
  10.0
  10.0.1
  oracle64-1.8.0.172
  oracle64-10.0.1
  
# Set global version
$ jenv global 10.0.1

$ java -version
java version "10.0.1" 2018-04-17
```

## Error Handling
### brew로 특정 자바 버전 설치 실패
cask에서 version에 따라 설치하는 기능이 미리 설치되지 않았다면 다음과 같은 에러 발생
```sh
$ brew cask install java8
Error: Cask 'java8' is unavailable: No Cask with this name exists.

# cask 설치 시 version 별 설치 가능하게 함
$ brew tap caskroom/versions
```

### global로 자바 버전을 바꾸었는데, 자바 버전이 안 바뀌어 있음
[jenv doctor 명령어를 사용해보라는 이슈](https://github.com/gcuisinier/jenv/issues/44#issuecomment-41462270)를 발견하고, 사용해봄.
```sh
$ jenv doctor
[OK]	No JAVA_HOME set
[ERROR]	Java binary in path is not in the jenv shims.
[ERROR]	Please check your path, or try using /path/to/java/home is not a valid path to java installation.
	PATH : /usr/local/Cellar/jenv/0.4.4/libexec/libexec:/Users/jb/.rbenv/shims:/Users/jb/.nvm/versions/node/v10.0.0/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
[ERROR]	Jenv is not loaded in your bash
[ERROR]	To fix : 	cat eval "$(jenv init -)" >> /Users/jb/.bash_profile
```
사용하기 위해서는 무언가 선행되야하는 작업이 있는듯 함.
[공식 사이트](http://www.jenv.be/)에서 메뉴얼 참고하여 해결.

## Reference
[osx - jenv 로 여러 버전의 java 사용하기. jdk 설치](http://junho85.pe.kr/736) 

