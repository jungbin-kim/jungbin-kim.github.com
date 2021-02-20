---
layout: post
title: Spring Cloud Gateway Web Handler 코드 분석
date: 2021-02-20 08:30:00 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring, Spring Cloud Gateway]
type: note
---

## Spring Cloud Gateway Web Handler 코드 분석
Spring Cloud Gateway(`v2.2.7.RELEASE`) 코드에서 Web Handler 부분을 분석한다.
WebHandler는 요청을 처리하기 위한 인터페이스이며, 
Spring Cloud Gateway에서는 WebHandler 를 구현한 FilteringWebHandler 에서 Route에 설정된 Filter들으로 Filter Chain을 만들어 처리한다.
이 포스트에서는 FilteringWebHandler.handle 부분과 이 부분에서 만드는 DefaultGatewayFilterChain 의 동작 코드를 살펴본다.

- 순서 요약: Client -> HttpWebHandlerAdapter.handle -> DispatcherHandler.handle -> RoutePredicateHandlerMapping.getHandlerInternal -> **FilteringWebHandler.handle (Gateway Filter Chain)**
- 앞 부분은 [이전 포스트 - Spring Cloud Gateway Handler Mapping 코드 분석](/spring/2021/02/13/spring-cloud-gateway-handler-mapping.html) 참조.


## FilteringWebHandler
- 위치: `org.springframework.cloud.gateway.handler.FilteringWebHandler`
- `org.springframework.web.server.WebHandler` 을 구현.
  - 웹 요청을 처리하기 위한 인터페이스
  - `Mono<Void> handle(ServerWebExchange exchange);` 메서드를 구현하도록 함.
- [`org.springframework.cloud.gateway.config.GatewayAutoConfiguration`](https://github.com/spring-cloud/spring-cloud-gateway/blob/v2.2.7.RELEASE/spring-cloud-gateway-server/src/main/java/org/springframework/cloud/gateway/config/GatewayAutoConfiguration.java#L247)에서 Bean으로 등록된다.
- 역할: 객체가 생성되면서 loadFilters 메서드를 통해 GlobalFilter 들을 GatewayFilter 들로 변경해서 멤버 변수로 가지고, handle 메서드로 웹 요청에 대해서 해당하는 필터들 실행.

```java
// 생성자. 
public FilteringWebHandler(List<GlobalFilter> globalFilters) {
	// loadFilters 에서 GlobalFilter -> OrderedGatewayFilter(GatewayFilter)로 변경하여 globalFilters 멤버 변수에 저장.
	this.globalFilters = loadFilters(globalFilters);
}
```

### FilteringWebHandler.handle
- 역할: 요청에 해당하는 필터 체인 생성 및 실행

```java
@Override
public Mono<Void> handle(ServerWebExchange exchange) {
	Route route = exchange.getRequiredAttribute(GATEWAY_ROUTE_ATTR);
	// 요청에 해당하는 Route 객체에 적용되야하는 gateway filter 들
	List<GatewayFilter> gatewayFilters = route.getFilters();
	// 멤버 변수로 가지고 있는 global filter 들
	List<GatewayFilter> combined = new ArrayList<>(this.globalFilters);
	// gateway filter + global filter
	combined.addAll(gatewayFilters);
	// 순서에 따라 정렬
	AnnotationAwareOrderComparator.sort(combined);

	//...

	// DefaultGatewayFilterChain는 아래 별도 설명. 요청에 대한 필터 체이닝의 시작점.
	return new DefaultGatewayFilterChain(combined).filter(exchange);
}
```

### DefaultGatewayFilterChain

- 위치: FilteringWebHandler 내부에 존재. Static Nested Class

```java
private static class DefaultGatewayFilterChain implements GatewayFilterChain {

	private final int index;

	private final List<GatewayFilter> filters;

	// 외부에서 생성할 경우 사용하는 생성자. FilteringWebHandler.handle 에서 생성한다.
	DefaultGatewayFilterChain(List<GatewayFilter> filters) {
		this.filters = filters;
		this.index = 0;
	}

	// 내부 filter 메서드에서만 사용. 상위 filterChain 객체를 기반으로 index가 증가된 filterChain 을 만들수 있는 생성자
	private DefaultGatewayFilterChain(DefaultGatewayFilterChain parent, int index) {
		this.filters = parent.getFilters();
		this.index = index;
	}

	public List<GatewayFilter> getFilters() {
		return filters;
	}

	@Override
	public Mono<Void> filter(ServerWebExchange exchange) {
		// defer를 사용하여 실행을 구독 시점까지 지연한다.
		return Mono.defer(() -> {
			if (this.index < filters.size()) {
				GatewayFilter filter = filters.get(this.index);
				// index가 증가된 DefaultGatewayFilterChain 객체 생성하여, 다음에 적용될 filter의 index 값을 갖도록 함.
				DefaultGatewayFilterChain chain = new DefaultGatewayFilterChain(this,
						this.index + 1);
				// GatewayFilter.filter 메서드에 exchange와 index가 증가된 chain 을 넘긴다.
				// GatewayFilter.filter 메서드는 입력으로 온 chain의 filter 메서드를 호출하여 반환함으로 다음 filter가 실행되도록 한다.
				return filter.filter(exchange, chain);
			}
			else {
				return Mono.empty(); // complete
			}
		});
	}

}
```
