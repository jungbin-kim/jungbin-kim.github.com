---
layout: post
title: Building WebAssembly on MacOS
date: 2018-09-29 21:35:43 +0900
published: true
comments: true
categories: [Web]
tags: [WebAssembly]
---

## C/C++ 코드를 WebAssembly로 빌드하기 위한 Mac OS X 환경 설정
[Emscripten 설치 가이드](https://webassembly.org/getting-started/developers-guide/)를 참고하여
C와 C++을 WebAssembly로 컴파일하기 위한 도구 `Emscripten` 설치

**Emscripten 설명:**
- [LLVM](https://ko.wikipedia.org/wiki/LLVM) 로 빌드함
    + LLVM은 크로스플랫폼 컴파일러. Clang으로 컴파일할 경우, 아키텍처(CPU 규격 ex. ARM, x86-64 등)에 관계없이 빌드 가능.
    (LLVM 에 대해서는 [나무위키](https://namu.wiki/w/LLVM)가 더 정리가 잘되있는 듯)
- C/C++ 코드를 asm.js 와 WebAssembly 로 컴파일하기 위한 도구
- C/C++ 코드를 웹에서 별도의 플러그인 없이 네이티브에 가까운 속도로 제공

**Emscripten 설치:**
```sh
# github 에서 소스 코드 다운로드
$ git clone https://github.com/juj/emsdk.git

# 소스 다운받은 폴더로 이동
$ cd emsdk

# 기 컴파일된 최신 SDK 설치 (시간이 좀 걸릴 수 있음)
$ ./emsdk install latest

# ~/.emscripten 파일에서 설치된 SDK 경로를 참조하도록 함
$ ./emsdk activate latest

# OS X 일 경우 - 현재 실행되고 있는 터미널 프롬프트에 PATH와 환경변수를 더해줌 (윈도우에서 환경변수 설정과 비슷)
$ source ./emsdk_env.sh
# 새로운 터미널 프롬프트를 실행해서 이 명령어를 실행하면 빈칸이 나옴. 영구적으로 하기 위해서는 ~/.bash_profile 파일을 수정 적용해야함
$ echo ${EMSCRIPTEN}
```

**Emscripten 작동 테스트:**

- 아래 c 코드를 `hello.c`라는 이름의 파일로 다른 폴더에 저장
```c
#include <stdio.h>
int main(int argc, char ** argv) {
  printf("Hello, world!\n");
}
```

- Emscripten 으로 해당 c 코드 WebAssembly로 빌드
    + Flag: `-s WASM=1`  -> 빌드 결과물 `.wasm` (기본은 `asm.js`)
    + Flag: `-o hello.html` -> `hello.html` 파일이 나옴. 이 HTML 파일에는 빌드 결과물이 import 되고 메인 함수 실행하여 console 결과물을 보여줌.
    + `hello.html`은 웹 서버로 접근해야함.
    로컬에서 테스트할 때 [Web Server for Chrome](https://chrome.google.com/webstore/detail/web-server-for-chrome/ofhbbkphhbklhfoeikjpcbhemlocgigb) 확장 프로그램 사용하여 테스트.
    + 간단한 코드라서 리소스를 얼마 안쓸 줄 알았으나 빌드하는데 CPU를 생각보다 많이 씀
```sh
$ cd {c project path}
$ emcc hello.c -s WASM=1 -o hello.html
```

- 결과물
{% include figure_with_caption.html
   url='/img/posts/2018-09-29-wasm-result.png'
   title='hello.html 실행 결과'
   width='70%' %}

## 후기
- C/C++ API 를 `.wasm`으로 만들었을 때, JS Wrapper 는 어떻게 만들어야되는가 또는 만들어주는가 이해 필요
- OpenCV.js 빌드 해보기
{% reference /notes/2018-10-03-webassembly-opencvjs/ %}

참고:
- [WebAssembly 초기 프로젝트 정보(2017.01)](https://www.devpools.kr/2017/01/21/webassembly-binaryen-emscripten/)
- [asm.js에 대해서(2013.04)](https://blog.outsider.ne.kr/927)