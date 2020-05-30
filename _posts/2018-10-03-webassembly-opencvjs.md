---
layout: post
title: Building OpenCV.js WebAssembly on MacOS
date: 2018-10-03 11:47:45 +0900
published: true
comments: true
categories: [Web]
tags: [WebAssembly, OpenCV]
type: note
---

## OpenCV 를 WebAssembly로 빌드

[WebAssembly로 빌드하는 방법에 관한 OpenCV 문서](https://docs.opencv.org/3.4.3/d4/da1/tutorial_js_setup.html)를 참고해서 진행.
해당 문서는 OpenCV(`C++`) 를 `Python` 스크립트를 실행하여 `WebAssembly` 파일과 그 내부 함수에 접근할 수 있게 해주는 `js` 파일을 빌드하는 방법에 대해서 기술.

## 환경 설정 (MacOS)

### Emscripten 설치
이전 글인 [C/C++ 코드를 WebAssembly로 빌드하기 위한 Mac OS X 환경 설정](../2018-09-29-webassembly-build-on-macos/)을 참고.

<span style="color:red">**주의:**</span>
- Emscripten 환경변수를 현재 터미널에 적용하는 `source ./emsdk_env.sh` 명령어는 새로운 터미널로 빌드를 실행할 때 다시 한번 해줘야함.
안해줄 경우, `emscripten_dir=None`이라는 아래와 같은 메시지를 볼 수 있음.
> Args: Namespace(build_dir='build_wasm', build_doc=False, build_test=False, build_wasm=True, clean_build_dir=False, config_only=False, emscripten_dir=None, enable_exception=False, opencv_dir='{opencv path}', skip_config=False)
Cannot get Emscripten path, please specify it either by EMSCRIPTEN environment variable or --emscripten_dir option.

### Python 설정
Python 2.7.10 사용.
다른 개발 환경 설정 시 다른 버전을 필요할 수도 있다면 [pyenv](https://github.com/pyenv/pyenv)를 설치해서 사용하는걸 추천.
```sh
$ brew install pyenv
$ pyenv init
# Load pyenv automatically by appending
# the following to ~/.bash_profile:

eval "$(pyenv init -)"
```
`~/.bash_profile` 파일에 접근해서 `eval "$(pyenv init -)"`를 추가하고 적용.
```sh
$ vi ~/.bash_profile
# eval "$(pyenv init -)" 추가
$ source ~/.bash_profile
```

위의 과정을 진행한 후에도 Install 할 때 에러가 발생한다면 다른 터미널을 열고 실행. OpenCV 폴더로 이동해서 해당 폴더에서 사용할 파이썬 버전 설정.
```
$ pyenv install 2.7.10
$ cd {opencv project}
$ pyenv local 2.7.10
$ pyenv versions
  system
* 2.7.10 (set by {현재 프로젝트 경로}/.python-version)
  3.7.0
```

<span style="color:red">**주의:**</span>
- [pyenv init 없이 그냥 install 할 경우](https://stackoverflow.com/questions/51551557/pyenv-build-failed-installing-python-on-macos) 설치가 안될 수 있으니 주의.
- 파이썬 `v3.7.0` 으로 OpenCV WebAssembly 빌드 실패하여 `v2.7.10`로 바꿈

### CMake(Cross Platform Make) 설치
[CMake](https://cmake.org/) 는 크로스플랫폼 환경에서 빌드, test, 패키징하기 위한 오픈소스 도구. OpenCV 내 모듈들을 빌드하기 위해 필요.
```sh
$ brew install cmake
```

## 빌드
[OpenCV Git repository](https://github.com/opencv/opencv)에서 코드를 받은 뒤 `v3.4`으로 빌드하면
`{OpenCV 프로젝트 폴더}/build_wasm/bin` 폴더에 `opencv_js.js`, `opencv_js.wasm`, `opencv.js` 파일들이 나옴.
아무런 파라미터가 없다면 `asm.js` 버전으로 빌드되며, `--build_wasm` 파라미터를 추가해줘야 `wasm` 파일로 빌드됨.

```sh
$ git clone https://github.com/opencv/opencv.git
$ cd opencv
$ git checkout -t origin/3.4
$ python ./platforms/js/build_js.py build_wasm --build_wasm
```

## 테스트
필요한 객체가 다 있는지 확인해보기 위해서 웹서버를 아래 프로젝트 구조처럼 만들고 [index.html 파일](https://gist.github.com/jungbin-kim/8f9102c5ebc3d20cb463751828d49cbc)을 접근하여 확인.
```
root
│   index.html
└───js
    │ opencv_js.wasm
    └ opencv.js
```
<span style="color:red">**주의:**</span>
- 커스텀 빌드하는 과정에서 매칭이 잘못된 경우는 js 바인딩이 되어 있는 것처럼 나와도 실제 해당 계산 실행 도중에 에러 발생 가능성이 존재.

## 결론
OpenCV 객체들이 다 바인딩되는 것은 아니고, 설정이 되어있는 것만 해줌. 따라서 OpenCV 라이브러리에 있는 원하는 API 또는 객체들을 사용하고 싶다면 빌드 설정을 커스텀해야함
