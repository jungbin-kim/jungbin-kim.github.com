---
layout: post
title: TypeError - Converting circular structure to JSON
date: 2018-07-22 08:31:01 +0900
published: true
comments: true
categories: [Web]
tags: [JavaScript]
---

## JS Object JSON.stringify 시 발생 에러
자기 자신을 참조하고 있는 JavaScript Object를 `JSON.stringify` 할 경우 발생.
```js
var obj = { x: 1, y: "2" };
obj.myself = obj;
JSON.stringify(obj);
// Uncaught TypeError: Converting circular structure to JSON
```
자기 자신을 참조하면 무한 루프가 발생되기 때문에 해당 에러가 발생한 듯.
내 경우는 JSON으로 만들 때 자기 자신을 참조하고 있는 부분은 불필요하여 참조하는 부분을 제외하고 stringify.
아래 참조는 JS Object의 Value 중 중복되는 참조가 있으면 그 Key 값은 제외하고 stringify. 

{% reference https://stackoverflow.com/questions/11616630/json-stringify-avoid-typeerror-converting-circular-structure-to-json %}