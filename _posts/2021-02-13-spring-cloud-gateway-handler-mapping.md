---
layout: post
title: Spring Cloud Gateway Handler Mapping 코드 분석
date: 2021-02-13 09:07:00 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring, Spring Cloud Gateway]
type: note
---

## Spring Cloud Gateway Handler Mapping 코드 분석
Spring Cloud Gateway(`v2.2.7.RELEASE`) 코드에서 Handler Mapping 부분(아래 이미지 음영 외 부분)을 분석한다.
Spring Cloud Gateway의 클라이언트 요청 처리는 Spring 프레임워크에서 처리하는 것과 동일하며, Gateway에 맞게 HandlerMapping 객체를 확장(RoutePredicateHandlerMapping)하여 사용한다.
{% 
   include figure_with_caption.html 
   url='/img/posts/2021-02-13-spring_cloud_gateway_diagram_handler_mapping.png'
   width='50%'
%}

- [이전 포스트 - Spring Cloud Gateway 소개](/spring/2020/05/29/spring-cloud-gateway-introduction.html)

## 클라이언트 요청이 처리되는 순서대로 코드 분석
- 순서 요약: Client -> **HttpWebHandlerAdapter.handle -> DispatcherHandler.handle -> RoutePredicateHandlerMapping.getHandlerInternal** -> Gateway Filter Chain
- 거쳐가는 객체가 더 있지만, 중요한 부분만 분석.

### HttpWebHandlerAdapter
- 위치: [`org.springframework.web.server.adapter.HttpWebHandlerAdapter`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/server/adapter/HttpWebHandlerAdapter.html)
- ServerWebExchange 객체는 filter 에서 많이 사용되는데 여기서 생성.

```java
@Override
public Mono<Void> handle(ServerHttpRequest request, ServerHttpResponse response) {
	if (this.forwardedHeaderTransformer != null) {
		request = this.forwardedHeaderTransformer.apply(request);
	}
	// ServerWebExchange를 생성
	ServerWebExchange exchange = createExchange(request, response);

	LogFormatUtils.traceDebug(logger, traceOn ->
			exchange.getLogPrefix() + formatRequest(exchange.getRequest()) +
					(traceOn ? ", headers=" + formatHeaders(exchange.getRequest().getHeaders()) : ""));

	// getDelegate 으로 대상 WebHandler를 가져와서 exchange를 넘긴다.
	// Spring Cloud Gateway의 경우나 @EnableWebFlux를 사용하는 경우, 대상 WebHandler = DispatcherHandler
	return getDelegate().handle(exchange)
			.doOnSuccess(aVoid -> logResponse(exchange))
			.onErrorResume(ex -> handleUnresolvedError(exchange, ex))
			.then(Mono.defer(response::setComplete));
}
```

### DispatcherHandler
- 위치: [`org.springframework.web.reactive.DispatcherHandler`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/reactive/DispatcherHandler.html)
- DispatcherHandler bean이 생성될 때, Application Context에서 HandlerMapping, HandlerAdapter, HandlerResultHandler 타입의 컴포넌트들을 찾아서 정렬한 뒤 멤버변수에 가지고 있는다.
- 멤버 변수:

```java
// HandlerMapping -- map requests to handler objects
@Nullable
private List<HandlerMapping> handlerMappings;
// HandlerAdapter -- for using any handler interface
@Nullable
private List<HandlerAdapter> handlerAdapters;
// HandlerResultHandler -- process handler return values
@Nullable
private List<HandlerResultHandler> resultHandlers;
```

- handle 메서드: request를 처리하기 위해 등록된 handler들을 실행. handle 메서드 코드를 보면 멤버변수들의 역할을 어느정도 짐작 가능.

```java
@Override
public Mono<Void> handle(ServerWebExchange exchange) {
	if (this.handlerMappings == null) {
		return createNotFoundError();
	}
	return Flux.fromIterable(this.handlerMappings)
			// (HandlerMapping) 요청 정보가 들어있는 exchange로 해당하는 Handler를 찾음. 
			.concatMap(mapping -> mapping.getHandler(exchange))
			.next()
			.switchIfEmpty(createNotFoundError())
			// (HandlerAdapter) invokeHandler 에서 this.handlerAdapters의 루프를 돌면서 해당하는 handlerAdapter를 찾고, 주어진 Handler로 요청을 처리.
			.flatMap(handler -> invokeHandler(exchange, handler))
			// (HandlerResultHandler) handleResult 에서 this.resultHandlers의 루프를 돌면서 해당하는 handleResult를 찾고, 응답 헤더를 수정하거나 응답에 데이터를 쓰는 것과 같은 처리.
			.flatMap(result -> handleResult(exchange, result));
}
```

### RoutePredicateHandlerMapping

- 위치: [`org.springframework.cloud.gateway.handler.RoutePredicateHandlerMapping`](https://github.com/spring-cloud/spring-cloud-gateway/blob/v2.2.7.RELEASE/spring-cloud-gateway-server/src/main/java/org/springframework/cloud/gateway/handler/RoutePredicateHandlerMapping.java)
- [`org.springframework.cloud.gateway.config.GatewayAutoConfiguration`](https://github.com/spring-cloud/spring-cloud-gateway/blob/v2.2.7.RELEASE/spring-cloud-gateway-server/src/main/java/org/springframework/cloud/gateway/config/GatewayAutoConfiguration.java#L257) 에서 Bean으로 등록.
- `org.springframework.web.reactive.handler.AbstractHandlerMapping` 를 상속받음.
  - AbstractHandlerMapping.getHandler
    - DispatcherHandler.handle 에서 handlerMapping 할 때 사용.
    - 구현체(ex. RoutePredicateHandlerMapping)에서 구현하도록한 getHandlerInternal 를 호출.
  - order 를 가지고 있음. (DispatcherHandler에서 정렬해서 가지고 있기 위한 HandlerMapping 순서이며, Spring Cloud Gateway에서는 RoutePredicateHandlerMapping를 order 1 로 설정.)
- [getHandlerInternal](https://github.com/spring-cloud/spring-cloud-gateway/blob/v2.2.7.RELEASE/spring-cloud-gateway-server/src/main/java/org/springframework/cloud/gateway/handler/RoutePredicateHandlerMapping.java#L79) 메서드:
  - exchange로 매핑되는 route 를 찾고, FilteringWebHandler webHandler 를 반환. route를 찾지 못하면 Mono.empty 반환.

```java
@Override
protected Mono<?> getHandlerInternal(ServerWebExchange exchange) {
  // ... 생략
  // lookupRoute: 별도 설명
  return lookupRoute(exchange)
      .flatMap((Function<Route, Mono<?>>) r -> {
        // ... exchange 업데이트 로직 생략
        // webHandler = FilteringWebHandler = Gateway Filter Chain 호출
        return Mono.just(webHandler);
      }).switchIfEmpty(Mono.empty().then(Mono.fromRunnable(() -> {
        // ... 매칭되는 RouteDefinition 를 찾지 못할 경우 로그 남기는 로직 생략
      })));
}
```

- [lookupRoute](https://github.com/spring-cloud/spring-cloud-gateway/blob/v2.2.7.RELEASE/spring-cloud-gateway-server/src/main/java/org/springframework/cloud/gateway/handler/RoutePredicateHandlerMapping.java#L127) 메서드:
  - RouteLocator 에 있는 routes 에서 predicate를 만족하는 route를 반환한다. 없거나 에러 발생 시 Mono.empty 반환.

```java
// 주석 및 코드 일부 생략
protected Mono<Route> lookupRoute(ServerWebExchange exchange) {
	return this.routeLocator.getRoutes() // Flux<Route> 반환
			// Route를 순서대로 검사
			.concatMap(route -> Mono.just(route).filterWhen(r -> {
				// route 의 predicate로 필터링
				return r.getPredicate().apply(exchange);
			})
					.doOnError(e -> logger.error(
							"Error applying predicate for route: " + route.getId(),
							e))
					.onErrorResume(e -> Mono.empty()))
			.next()
			.map(route -> {
				// 현재 버전에선 아직 구현이 안되어 있지만, Route의 Validation 체크를 하는 부분
				validateRoute(route, exchange);
				return route;
			});
}
```

## 참고
- [spring cloud gateway 구조](https://dlsrb6342.github.io/2019/05/14/spring-cloud-gateway-%EA%B5%AC%EC%A1%B0/) ODODODODO 블로그