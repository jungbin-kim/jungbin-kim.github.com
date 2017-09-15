---
layout: post
time: "2nd Semester 2014"
title: "Physics Animation Term Project: Rope Simulation"
title_ko: "물리 기반 애니메이션: Rope Simulation"
skills: [JavaScript, Three.js]
description: ""
image: ""
categories: [project]
---

# UST Physics Animation Term Project
- 주제: 현실 물리 기반으로 동작하는 3D model 구현
- 기간: 2014년 2학기
- 현실 물리 세계 법칙에 따른 동작 공식을 JavaScript로 구현하였으며, 그 공식에 따라 움직이는 물체들을 Three.js를 이용하여 Virtual 3D 공간에 표현. 
- [Github 정리 페이지](https://github.com/jungbin-kim/web/tree/master/threejs/physics-animation/term-project)

#### Goal
1. Model a rope with multiple particles
2. Implement bending feature
3. Use of implicit integrator
4. Collision
 - Against surroundings
 - Rope / Rope interaction

#### Procedure
1. Modeling
 - Particle
 - Rope
 - Plane
 - Cube
2. Implicit Method
 - Implicit Euler Integration
3. Collision
 - between Particle and Plane
 - between Ropes

#### Result
- Implicit Euler Method

[![Link](http://img.youtube.com/vi/urBGSMNdgpQ/0.jpg)](http://www.youtube.com/watch?v=urBGSMNdgpQ)

- Explicit Euler Method

[![Link](http://img.youtube.com/vi/-FTIIJMbzqM/0.jpg)](http://www.youtube.com/watch?v=-FTIIJMbzqM)

#### Conclusion
1. Collision particle and plane
 - Sometimes miss the collision (tunneling effect)
2. Collision between ropes method is not that efficient
3. Compare to explicit method
 - more stable

#### Reference
[Physics for JavaScript Games Animation Simulations](https://github.com/devramtal/Physics-for-JavaScript-Games-Animation-Simulations)

***
Continued from [Homework2](https://github.com/jungbin-kim/web/tree/master/threejs/physics-animation/homework2)