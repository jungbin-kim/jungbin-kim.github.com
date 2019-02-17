---
layout: post
title: Decrease webpack bunlding file size
date: 2019-02-17 00:12:21 +0900
type: post
published: true
comments: true
categories: [Web]
tags: [JavaScript]
---

# Webpack bundling 파일 사이즈 줄이기(Tree Shaking)
이 글은 개인적으로 [시간 계산이 필요한 크롬 확장 프로그램 앱](https://github.com/jungbin-kim/Clockify-Calculator-Chrome-Extension)을 개발하다가 빌드 파일 크기 문제가 발생하면서 작성하게 되었습니다. (사용환경: `Webpack v4.29.3`)

## 문제 분석 
**문제 사항**: Webpack bundling 파일 용량이 너무 크다.
- webpack으로 빌드하지 않았을 때 프로젝트 폴더 용량(라이브러리 min file 포함): `415 KB`
  - Pure HTML, JS, CSS + minified lib(lodash, moment)
- webpack으로 빌드한 폴더의 용량: `4.2 MB`
  - Webpack `development` mode build: 4.2 MB
  - Webpack `production` mode build: 1.6 MB

Bundling 된 파일의 용량 증가 현상을 분석하기 위해 [Webpack BundleAnalyzerPlugin](https://www.npmjs.com/package/webpack-bundle-analyzer) 사용하여 분석하였습니다. 
아래 코드처럼 빌드환경에 해당 플러그인을 포함하여 실행하면 Bundling 파일 분석결과 페이지를 자동으로 열어줍니다.

```js
// webpack.config.js 에 플러그인 포함 코드
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
 
module.exports = {
  plugins: [
    new BundleAnalyzerPlugin()
  ]
}
```

{% 
   include figure_with_caption.html 
   url='/img/posts/2019-02-17-BundleAnalyzerPlugin.gif' 
   title='분석 플러그인 실행 화면(Moment.js 최적화 후)'
   width='80%'
   description='' 
%}

**분석결과:** 사용하고 있는 라이브러리들인 moment.js와 lodash 의 용량이 크다는 것을 알 수 있었습니다. 

## Moment.js 용량 줄이기
**원인:** 날짜 관련 라이브러리인 [Moment.js](https://momentjs.com/)는 모든 locale이 다 들어가서 용량이 커집니다. 

**실행:** Webpack 플러그인인 [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin)을 사용하여 locale을 제외하고 bundling 파일에 넣으니 용량이 다음과 같이 줄었습니다.
- Webpack `development` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) 사용: `2.9 MB`
- Webpack `production` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) 사용: `570 KB`

이외에도 [Moment.js의 대체제를 이용하는 방법](https://github.com/you-dont-need/You-Dont-Need-Momentjs)도 존재합니다.
만약 용량을 더 줄이고 싶다면, 같은 기능을 갖지만 용량이 적은 다른 라이브러리가 있는지 찾아보고 적용하는 방법도 있습니다.

## Lodash 용량 줄이기
**원인:** [lodash-es](https://www.npmjs.com/package/lodash-es)는 필요한 메소드만 import 해서 사용하여 라이브러리 전체가 들어가지 않을 것으로 생각하였습니다. 
하지만 `BundleAnalyzerPlugin`으로 본 결과 라이브러리 전체가 다 들어갔습니다. 

**실행:** lodash 메소드 import 방법 조정 및 [LodashModuleReplacementPlugin](https://github.com/lodash/lodash-webpack-plugin) 적용하여 다음과 같은 결과를 얻을 수 있었습니다.

처음에는 `메소드 import 방법 1`을 사용하였지만 `development` mode에서는 큰 효과를 볼 수 없었습니디. 
```js
// 메소드 import 방법 1 => development mode에서는 효과가 미미했다.
import { map, reverse } from 'lodash-es'
```

- Webpack `development` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) + 메소드 import 방법 1 + [LodashModuleReplacementPlugin](https://github.com/lodash/lodash-webpack-plugin)(Babel 사용 안함): `2.6 MB`
- Webpack `production` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) + 메소드 import 방법 1 + [LodashModuleReplacementPlugin](https://github.com/lodash/lodash-webpack-plugin)(Babel 사용 안함): `388 KB`


그 다음으로는 [Tree shake Lodash Solution 2 ( no babel )](https://medium.com/@martin_hotell/tree-shake-lodash-with-webpack-jest-and-typescript-2734fa13b5cd)을 참고(babel을 사용하지 않았기 때문에)하여 `메소드 import 방법 2`를 적용해보았습니다.
```js
// 메소드 import 방법 2 => development mode에서는 효과가 대단했다.
import map from 'lodash/map'
import reverse from 'lodash/reverse'
```
- Webpack `development` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) + 메소드 import 방법 2: `720 KB`
  + 플러그인을 사용하지 않고도 큰 효과가 있었다.
- Webpack `development` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) + 메소드 import 방법 2 + [LodashModuleReplacementPlugin](https://github.com/lodash/lodash-webpack-plugin)(Babel 사용 안함) : `426 KB`
- Webpack `production` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) + 메소드 import 방법 2 + [LodashModuleReplacementPlugin](https://github.com/lodash/lodash-webpack-plugin)(Babel 사용 안함): `388 KB`
  + 결국 `production` mode에서는 import 방법과 관계없이 파일 용량이 같았습니다.

## inline source map 제거
배포용은 bundling 파일안에 webpack bundling 파일과 origin 소스를 연결해주는 `source map`을 제거하여 빌드합니다.
- Webpack `production` mode + [MomentLocalesPlugin](https://www.npmjs.com/package/moment-locales-webpack-plugin) + [LodashModuleReplacementPlugin](https://github.com/lodash/lodash-webpack-plugin)(Babel 사용 안함) + source map 제거: `59 KB`


## 결론
Webpack과 같은 bundling tool 에서 사용하지 않는 코드를 제외 시키는 것을 `Tree Shaking`이라고 한다.
불필요한 코드를 bundling 파일에 추가하지 않는 방법들을 통해 파일 사이즈를 줄여 초기 로딩 시 다운로드 속도 개선이 가능하다.

## 참고
- [Put Your Webpack Bundle On A Diet - Part 3](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/)
- [Webpack 4의 Tree Shaking에 대한 이해](http://huns.me/development/2265)