---
layout: post
title: Webpack optimize-css-assets plugin
date: 2020-01-18 09:00:00 +0900
published: true
comments: true
categories: [Web]
tags: [Webpack, Bundling, ErrorHandling]
type: note
---

## 현상
개발 환경에서는 잘 동작하던 기능이 스테이징 환경에서 이상 동작하는 현상이 발생하였다. 
그 현상은 특정 메뉴 영역의 mouseout 이벤트가 제대로 동작하지 않는 것이었다.

## 분석
- 문제가 발생한 특정 메뉴 영역의 z-index가 원래 값에서 더 줄어 있었다. 그래서 그 영역 레이어보다 z-index가 큰 레이어에 가려서 mouseout 이벤트가 영역 중간에 발생하였다.

<span style="display: table; margin-left: auto; margin-right: auto;">
  ![](../../img/posts/2020-01-18-issue.png)
</span>

- CSS에 영향을 미칠 수 있는 부분을 생각해보았다. Webpack 번들링 옵션쪽이 가장 유력하였으며, CSS를 변경하는 옵션이 있는지 찾아보았다.
- 스테이징 환경에서는 CSS 를 최적화 / 최소화 할 수 있는 [Optimize CSS Assets Webpack Plugin](https://github.com/cssnano/cssnano)을 사용하고 있었다.

### cssnano on Optimize CSS Assets Webpack Plugin

- 해당 플러그인은 CSS 처리를 위해 [cssnano](https://github.com/cssnano/cssnano)를 사용한다. 
- CSS 최적화 기능 중에는 zindex를 자동으로 정렬해서 낮은 값으로 변경해주는 옵션이 있다. 
  - z-index 값은 상대적으로 레이어 간의 위아래를 구분하기 위해 사용된다. 레이어가 엄청 많지 않은 경우 1, 9999 등 엄청 크거나 작은 값으로 최상위/최하위를 만들어 쓰는 경우가 많다. 
  - '이런 옵션이 있다는건 z-index값이 크면 웹사이트 퍼모먼스에 영향이 있어서 인가?' 라는 궁금증이 있어서 검색을 해보니 퍼포먼스에 영향은 없다고 한다.(Stackoverflow: [z-index, how does it affect performance?](https://stackoverflow.com/a/5887272)) 
  - 내 생각에는 css 최소화를 할때 9999 같이 선언된 값을 조금이라도 작게해서 용량을 낮추려는 노력인 것 같다.

[cssnano 문서](https://cssnano.co/optimisations/)를 보니 zindex 수정해주는 기능은 설정을 통해서 된다. 별다른 설정을 하고 있진 않은데 왜 zindex를 수정해주는걸까? 바로 버전 문제였다. 

- 사용하고 있는 `optimize-css-assets-webpack-plugin`의 버전은 `v4.0.3`이고, [v4.0.3의 package.json](https://github.com/NMFR/optimize-css-assets-webpack-plugin/blob/v4.0.3/package.json)를 보면 `"cssnano": "^3.10.0"`를 사용한다.
- 그리고, [cssnano v4.0.0 릴리즈 노트](https://github.com/cssnano/cssnano/releases/tag/v4.0.0-rc.0)를 보면 이때부터 zindex 를 옵션을 줘야지만 적용되는 것으로 변경되었다. 

## 해결 방법
[After built the z-index changed](https://github.com/vuejs-templates/webpack/issues/614)를 보면 비슷한 현상에 대한 리포트가 있다. 그 답변 중 하나인 [only use safe optimizations for css minification](https://github.com/vuejs-templates/webpack/commit/54d3bd247d421f8ce9938988283ce9c7badf554f)을 적용해본다.

```js
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')

const webpackConfig = {
  // ...
  plugins: [
    new OptimizeCSSPlugin({
      cssProcessorOptions: {
        safe: true
      }
    })
  ]
  // ...
}
```
css 최소화 처리 옵션으로 safe를 넣어 z-index 변경을 해주지 않을 수 있다. (또는 버전업을 통해 해결할 수도 있다.)
