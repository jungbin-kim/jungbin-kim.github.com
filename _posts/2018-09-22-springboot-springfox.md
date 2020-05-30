---
layout: post
title: SpringFox - API Documentation on Spring Boot
date: 2018-09-22 15:40:50 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring Boot]
type: note
---

## API Documentation 이란

SpringFox는 Spring 기반의 API 문서화를 위한 프로젝트이며, 코드 상에 annotation 함으로 API 요청/응답 문서를 자동으로 생성해줌.
[SpringFox Github Page](http://springfox.github.io/springfox/)에서는 다음과 같이 소개.
> Automated JSON API documentation for API's built with Spring

어떤 API 이던지 사용하기 위해 만들어진 API 라면 사용하는 사람이 그 API에 대한 정보를 알아야함.
어떤 요청을 할 때 어떤 응답이 오는지, 그 응답의 구조는 무엇인지 등을 알아야 어떤 API 를 사용할 때 어떤 응답이 오는지 예측 가능하고 그에 따라 개발 작업을 진행 가능.
이를 모르는 상태로 개발을 해야한다면 요청에 대한 여러가지 경우의 수들을 다 테스트하면서 개발을 해야하기 때문에 개발 피로도가 높음.

서버 자원을 사용하기 위해 HTTP 기반의 REST API 요청을 많이 사용하는데 그에 관한 문서화를 위한 스펙들이 있음.
[Swagger](http://swagger.io/), [RAML](https://raml.org/) 및 [jsonapi](http://jsonapi.org/) 들이 그 예.
이러한 문서화 스펙에 대한 여러 표준에 대한 Spring framework 내에서 사용 가능하게 만든 구현체가 `SpringFox` 이다.

**Swagger:**
- 사람과 컴퓨터가 코드에 접근하지 않고 서비스 기능에 대해서 이해할 수 있게 하기 위한 RESTful API 인터페이스.
- 2010년 RESTful API를 디자인하기 위한 오픈소스 규격으로 시작하여 2015년에는 SmartBear Software 에 인수되어 OpenAPI 라는 이름으로 바뀜.
- JSON 과 YAML format 지원

**RAML:**
- REST 원리가 담긴 HTTP-based APIs 를 정의하기 위한 언어
- YAML 1.2 format

**jsonapi:**
- 클라이언트가 어떻게 resource를 가져오거나 수정하는 요청을 하는지 서버가 그러한 요청을 받아서 어떻게 응답하는지에 대한 규격
- JSON format

## Implementation
- `build.gradle` 파일 내 라이브러리 디펜던시 추가

```gradle
dependencies {
    // ..
    // api docs 를 위해 디펜던시 추가
    compile "io.springfox:springfox-swagger2:2.9.2"
    compile "io.springfox:springfox-swagger-ui:2.9.2"
}
```

- SpringFox 설정 파일인 `SpringFoxConfig.java`를 추가

```java
@Configuration
@EnableSwagger2
public class SpringFoxConfig {
    @Bean
    public Docket apiDocket() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build();
    }
}
```

- 프로젝트 시작하고 `http://localhost:8080/swagger-ui.html` 로 접속하면 swagger UI 를 볼 수 있음
    + controller 메소드 내에서 별도의 method mapping 이 없으면 모든 메소드가 다 나옴
{% include figure_with_caption.html
   url='/img/posts/2018-09-22-springboot2-springfox.png'
   title='Swagger UI'
   width='70%' %}


## Error Handling

### 에러 메시지: `java.lang.NumberFormatException: For input string: ""`
`@ApiImplicitParams`이나 `@ApiModelProperty` 사용시 springFox model 관련 annotation을 할 때 에러 메시지가 남는 경우 존재.
에러가 난다고 해서 작동을 안하진 않으며 별 영향없음.

**해결 방법:**
swagger 라이브러리 version (1.5.20)이 오래되었을 수 있음. 새로운 버전으로 추가해줌.
([참고 글](https://github.com/springfox/springfox/issues/2265#issuecomment-413286451))

### Data model 내 선언한 `@validated` annotation 이 정상 작동하지 않음
하나의 데이터 모델을 서로 다른 상황(POST, PUT 메소드)에서 다른 validation 하기 위해 `@validated`를 사용.
그래서 POST 와 PUT API 내 Request 데이터 모델이 Swagger UI에서 나타날때 Validation에 따라 다르게 보일 것을 기대함.
하지만, SpringFox 에서 아직 지원을 하지 않는 것 같으며 [현재 개발 중](https://github.com/springfox/springfox/issues/2307)이라는 글을 찾음.

### `@RequestMapping`내 `consumes = {MediaType.MULTIPART_FORM_DATA_VALUE}`하면 UI 에서 content-type header 에 안붙음
`consumes`에 넣은 Media type 이 UI 상에서 테스트 할 때 안 붙어 간다는 [문제 보고](https://github.com/springfox/springfox/issues/1361).

**해결방법:**
`@RequestMapping` 내 consumes 부분을 지우고, 해당 메소드에 아래와 같은 Annotation을 추가.
```java
@ApiImplicitParams({
    @ApiImplicitParam(name = "Content-Type", defaultValue = "multipart/form-data", paramType = "header"),
})
```
해당 Annotation은 Swagger UI 상에서 아래 사진과 같이 나타나게 해줌.
{% include figure_with_caption.html
   url='/img/posts/2018-09-22-springboot2-springfox2.png'
   title='@ApiImplicitParams'
   width='70%' %}
