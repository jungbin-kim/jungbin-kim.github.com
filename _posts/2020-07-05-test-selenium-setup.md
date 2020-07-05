---
layout: post
title: How to setup Selenium on Mac
date: 2020-07-05 07:45:00 +0900
published: true
comments: true
categories: [Test]
tags: [Selenium, Setup]
type: note
---

# Selenium 소개
Selenium 는 브라우저를 자동화한다.
Selenium WebDriver, Selenium IDE, Selenium Grid 세가지 프로젝트들이 있다.

* Selenium WebDriver: 사용자가 브라우저를 이용하는 것처럼 로컬 또는 원격 컴퓨터에서 브라우저를 구동.
* Selenium IDE: 브라우저에서 테스트를 쉽게 기록하고 재생할 수 있는 Chrome 및 Firefox 확장 프로그램.
* Selenium Grid: 많은 컴퓨터에서 동시에 테스트를 실행하여, 여러 브라우저 및 운영 체제에서 테스트하는 시간을 줄일 수 있다.

참조: 공식 홈페이지([selenium.dev](https://www.selenium.dev/))

# 목적
* 기능 개발 후, 테스트 서버에 배포하고 나서 개발자 테스트 과정이 반복적인 부분이 있어서 스크립트로 짜두면 자동으로 할 수 있지 않을까 싶었다.
* JUnit 같은 프레임워크 내에서 제공해주는 단위 테스트 외에 시스템(프론트엔드+백엔드)을 통합 테스트하고 싶었다.

# Setup

## 1. 크롬 드라이버 설치

```sh
$ brew cask install chromedriver
==> Downloading https://chromedriver.storage.googleapis.com/83.0.4103.39/chromed
######################################################################## 100.0%
==> Verifying SHA-256 checksum for Cask 'chromedriver'.
==> Installing Cask chromedriver
==> Linking Binary 'chromedriver' to '/usr/local/bin/chromedriver'.
🍺  chromedriver was successfully installed!
```

## 2. Install Selenium
```sh
$ pip3 install --user selenium
```

### 권한이 없는 시스템 폴더에 설치하려는 문제
* 실행 커맨드: `$ pip3 install selenium`
* 에러 메시지:

```
Could not install packages due to an EnvironmentError: [Errno 13] Permission denied: 'RECORD'
Consider using the `--user` option or check the permissions.
```

* 헤결 방법: `--user` 옵션을 붙여서 시스템 폴더가 아닌 유저 폴더에 설치한다.
* 참조: [github issue](https://github.com/googlesamples/assistant-sdk-python/issues/236#issuecomment-383039470)

### 셀레니움 설치 간 python 문제 발생
* 에러 메시지:

```
pip is configured with locations that require TLS/SSL, however the ssl module in Python is not available.
```

* 해결 방법: Mac에서 기본 제공되는 Python3 에 ssl 모듈이 설치가 안되어있는 것이 원인인 것 같다. `$ brew reinstall python`을 통해 python을 다시 설치한다.


## 3. Automate Script
* python 스크립트 작성 (파일명: `selenium-test.py`)

```python
# selenium의 webdriver를 가져온다.
from selenium import webdriver
# brew 로 설치된 chromedriver의 path
path = '/usr/local/bin/chromedriver' 
# 크롬 드라이버를 사용
browser = webdriver.Chrome(path)
# 브라우저에 띄우고 싶은 URL 입력. 이 경우 로그인부터 하기 위해 로그인창에 접근한다.
browser.get('https://login.toast.com')
# 로그인 창에서 자동으로 정보를 입력
browser.find_element_by_xpath("//input[@type='text']").send_keys("********")
browser.find_element_by_xpath("//input[@type='password']").send_keys("********")
# 입력된 로그인 정보 제출
browser.find_element_by_xpath("//button[@type='submit']").click()
# 로그인 이후, 확인이 필요한 페이지로 이동
browser.get('https://after-login.toast.com')

# 확인하고 싶은 로직. 여기선 테스트로 refresh 를 0.5에 한번씩 하도록 했다.
import time
max_time = 5
start_time = 0
refresh_time_in_seconds = 0.5
while(start_time < max_time):
    browser.refresh()
    start_time += refresh_time_in_seconds
    time.sleep(refresh_time_in_seconds)

browser.quit()
```

* 실행: `$ python3 selenium-test.py`


### chromedriver 개발자를 확인할 수 없다는 에러
* 에러 메시지:

```
개발자를 확인할 수 없기 때문에 ‘chromedriver’을(를) 열 수 없습니다.
```

* 해결 방법: chromedriver가 brew로 다운로드 한 프로그램이기 때문에 처음 실행할 때 사용자 확인을 요청받는데, 해당 속성 제거한다.

```sh
$ cd /usr/local/Caskroom/chromedriver/
# 폴더 내 버전 확인 후 이동
$ cd 83.0.4103.39
$ xattr -d com.apple.quarantine chromedriver
``` 

* 참조: [Unable to launch the chrome browser](https://stackoverflow.com/questions/60362018/macos-catalinav-10-15-3-error-chromedriver-cannot-be-opened-because-the-de)

# 결론
* 간단한 기능을 확인할 경우는 스크립트 짜는게 더 힘들 수 있다.
* 계속적으로 정상 동작 확인이 필요할 경우, 그 기능에 대한 테스트 스크립트를 기록(git 등)으로 남겨 유지 보수가 필요할 것 같다.
