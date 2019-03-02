---
layout: post
title: Machine Learning by Stanford University (Andrew Ng) on Coursera
date: 2018-07-21 23:35:48 +0900
type: post
published: true
comments: true
categories: [MachineLearning]
tags: [Coursera, Machine Learning]
---

## Coursera Machine Learning 강의를 듣고
이 강의를 듣게된 동기는 회사에서 Machine Learning 관련 업무를 맡을 뻔해서, 유투브에서 관련 강의/정보들을 찾아봄.
그 중 [머신러닝 / 딥러닝 강의 7가지 추천](https://youtu.be/LBexv9M-SBc)에서 [Andrew Ng 교수님의 Machine learning 강의](https://www.coursera.org/learn/machine-learning)을 알게됨.  
결국 실무를 맡지는 않았지만, 이왕 시작한 강의였기 때문에 끝까지 듣게됨.

강의 내용을 이해하고, 강의에서 배운 수식을 Octave 코드로 작성하여 Matrix 계산하는게 생각보다 쉽지 않았음.
수식에서 나타난 vector 값을 Matrix 로 잘!! 만들어서 계산해야함.
프로그래밍의 기술적인 성장이나 머신러닝 프레임워크 사용법을 배우길 기대한다면 이 강의는 비추천. 
어떤 공식을 모델링하거나 Machine Learning의 기본적인 경험을 해보고 싶다면 추천. 

개인적으로는 대학 때 배운 공학수학과 확률 및 랜덤 프로세스, 대학원 때 수강한 물리기반 애니메이션이 도움이 되었음. 
수강한 적은 없지만, 수치해석(Numerical analysis) 과목도 근사값을 구한다는 점에서 도움이 될 것 같음.
공학수학에서는 역학적인 조건으로 공식을 모델링하는 반면, 머신러닝에서는 데이터를 통해 공식(Hypothesis function, h, 가설함수)을 모델링함.
Classification을 할 때 검사 데이터가 특정 분류에 속할 확률을 구하는데 확률 개념이 들어감. 
하지만, 해당 수업 내에서는 확률 및 랜덤 프로세스처럼 확률에 대해서 깊게 들어가진 않음.

### 강의 참고 자료 

- Week 1 Introduction: [참고](http://www.kwangsiklee.com/ko/2017/07/corsera-machine-learning-week1-%EC%A0%95%EB%A6%AC/)

- Week 2 Linear Regression with Multiple Variables: [참고](http://www.kwangsiklee.com/ko/2017/07/corsera-machine-learning%EC%9C%BC%EB%A1%9C-%EA%B8%B0%EA%B3%84%ED%95%99%EC%8A%B5-%EB%B0%B0%EC%9A%B0%EA%B8%B0-week2/)

- Week 3 Logistic Regression: [참고](http://www.kwangsiklee.com/ko/2017/07/corsera-machine-learning%EC%9C%BC%EB%A1%9C-%EA%B8%B0%EA%B3%84%ED%95%99%EC%8A%B5-%EB%B0%B0%EC%9A%B0%EA%B8%B0-week3/)

- Week 4 Neural Networks: Representation: [참고](http://www.kwangsiklee.com/ko/2017/08/corsera-machine-learning%EC%9C%BC%EB%A1%9C-%EA%B8%B0%EA%B3%84%ED%95%99%EC%8A%B5-%EB%B0%B0%EC%9A%B0%EA%B8%B0-week4/)

- Week 5 Neural Networks: Learning: [참고](http://www.kwangsiklee.com/ko/2017/11/coursera-machine-learning%EC%9C%BC%EB%A1%9C-%EA%B8%B0%EA%B3%84%ED%95%99%EC%8A%B5-%EB%B0%B0%EC%9A%B0%EA%B8%B0-week5/)

- Week 6 Advice for Applying Machine Learning: [참고](http://www.kwangsiklee.com/ko/2017/11/coursera-machine-learning%EC%9C%BC%EB%A1%9C-%EA%B8%B0%EA%B3%84%ED%95%99%EC%8A%B5-%EB%B0%B0%EC%9A%B0%EA%B8%B0-week6/)

- Week 7 Support Vector Machines
{% reference https://www.popit.kr/coursera-machine-learning%EC%9C%BC%EB%A1%9C-%EA%B8%B0%EA%B3%84%ED%95%99%EC%8A%B5-%EB%B0%B0%EC%9A%B0%EA%B8%B0-week7/ %}

- Week 8 Unsupervised Learning
{% reference https://fabj.tistory.com/8 %}

- Week 9 Anomaly Detection
{% reference https://fabj.tistory.com/9 %}

- Week 10 Large Scale Machine Learning
{% reference https://fabj.tistory.com/11 %}

- week 11 Application Example: Photo OCR
{% reference https://www.slideshare.net/freepsw/coursera-machine-learning-by-andrew-ng/133 %}

### 과제 코드
{% reference https://github.com/jungbin-kim/coursera-machine-learning %}
