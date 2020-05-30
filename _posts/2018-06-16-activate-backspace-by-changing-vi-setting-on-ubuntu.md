---
layout: post
title: Activate back-space by changing vi setting on Ubuntu
date: 2018-06-16 16:27:06 +0900
published: true
comments: true
categories: [Linux]
tags: [Ubuntu, vi]
type: note
---

## Ubuntu에서 vi setting 변경하여 백스페이스 활성화
Docker로 설치한 Ubuntu에서 vi로 파일을 수정할려고하는데, 
백스페이스를 누를 때 이상한 글씨가 써지는 현상이 있었음. 

```sh 
# vi option 추가
$ echo "set autoindent \nset number \nset bs=2 \nset nocp" >> ~/.exrc
# 설정 적용
$ source ~/.exrc
```

- autoindent: 텍스트에 추가되는 각 행은 앞의 행과 같은 열에서 시작 
- number : 행 번호
- bs: back space 사용 (vim에서는 `indent,eol,start` 이 값으로도 사용되는 것 같음)
- nocp: vim 전용 기능 사용

## 참고
- [Ubuntu Vi 백스페이스 및 방향키](https://19bantedkoo.blogspot.com/2014/07/ubuntu-vi.html)
- [vi 환경설정을 위한 .exrc 설명](https://devkk.tistory.com/181)
- [.vimrc 설정 방법 내에서 bs 옵션](https://github.com/johngrib/simple_vim_guide/blob/master/md/vimrc.md#backspace-bs)