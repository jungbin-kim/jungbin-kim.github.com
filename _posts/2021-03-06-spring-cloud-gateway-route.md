---
layout: post
title: Spring Cloud Gateway RouteDefinition & Route 코드 분석
date: 2021-03-06 15:30:00 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring, Spring Cloud Gateway]
type: note
---

## Spring Cloud Gateway RouteDefinition & Route 코드 분석
Spring Cloud Gateway는 요청을 라우팅하는 것에 대해 정의하는 방법은 크게 두 가지가 있다. 자바 코드로 정의하는 방법인 Java DSL(Domain-Specific Languages)과 `application.yml` 과 같은 설정 파일에서 정의하는 방법이다. 
<br>
[이전 글 - Spring Cloud Gateway RouteDefinitionLocator & RouteLocator 코드 분석](/spring/2021/02/27/spring-cloud-gateway-route-locator.html) 에서는 이렇게 정의된 route 정보들을 어떻게 메모리에 가지고 있는지를 알아보았다면, 이번 글에서는 라우팅 정보를 가지고 있는 Route 객체에 대해 살펴본다.

## RouteDefinition

- 위치: `org.springframework.cloud.gateway.route.RouteDefinition`
- `application.yml` 과 같은 설정 파일에서 정의한 라우팅 정보들을 인스턴스화 할 수 있는 class ([이전 글 PropertiesRouteDefinitionLocator 부분](/spring/2021/02/27/spring-cloud-gateway-route-locator.html#propertiesroutedefinitionlocator) 참고)

```java
@Validated
public class RouteDefinition {

	private String id;

	// Route 매칭 조건인 Predicate는 하나 이상 있어야 한다.
	@NotEmpty
	@Valid
	private List<PredicateDefinition> predicates = new ArrayList<>();

	// 요청이 어떤 필터들을 거쳐야하는지에 대한 정보를 가진다.
	@Valid
	private List<FilterDefinition> filters = new ArrayList<>();

	// 라우팅될 서비스(Proxied Service)의 uri 정보
	@NotNull
	private URI uri;

	// 기타 데이터(공통화할 수 없는 라우팅 정보)들을 저장할 수 있는 객체
	private Map<String, Object> metadata = new HashMap<>();

	private int order = 0;

	// 빈 생성자로 객체를 생성한 뒤, setter로 값을 넣을 수 있다.
	public RouteDefinition() {	}

	// text를 입력 파라미터로 받아서 그 text를 파싱해서 RouteDefnition 객체를 만들 수 있다.
	// 하지만, 해당 버전의 코드에서는 사용되는 곳을 찾을 수 없었다.
	public RouteDefinition(String text) {
		// name=value,name=value
		int eqIdx = text.indexOf('=');
		if (eqIdx <= 0) {
			throw new ValidationException("Unable to parse RouteDefinition text '" + text
					+ "'" + ", must be of the form name=value");
		}
		// 맨처음 = 의 이전 값은 id로 처리한다.
		setId(text.substring(0, eqIdx));

		// id 이후 String은 , 을 기준으로 배열로 만든다.
		String[] args = tokenizeToStringArray(text.substring(eqIdx + 1), ",");

		// 배열의 가장 처음 값은 proxied service uri
		setUri(URI.create(args[0]));

		// 배열의 처음 값을 제외한 요소들은 predicate 객체로 만들어서 멤버변수 predicates에 넣어준다.
		for (int i = 1; i < args.length; i++) {
			this.predicates.add(new PredicateDefinition(args[i]));
		}

		// 해당 생성자는 멤버변수 filters에 데이터를 넣을 수 없다.
	}

	//... getter, setter, equals, hashCode, toString 생략
}
```

- `RouteDefinition(String text)` 생성자 테스트

```java
@Test
public void testRouteDefinitionFromText() {
	String text = "thisIsId=https://blog.jungbin.kim,Host=*.example.com";
	RouteDefinition routeDefinition = new RouteDefinition(text);
	System.out.println(routeDefinition.toString());
	// RouteDefinition{id='thisIsId', predicates=[PredicateDefinition{name='Host', args={_genkey_0=*.example.com}}], filters=[], uri=https://blog.jungbin.kim, order=0, metadata={}}
}
```

- RouteDefinition 객체에는 Predicate, Filter가 PredicateDefinition, FilterDefinition로 저장되어, 실제 사용 가능한 Predicate, Filter인지는 알 수 없다.


## Route

- 위치:`org.springframework.cloud.gateway.route.Route`

```java
public class Route implements Ordered {

	private final String id;

	private final URI uri;

	private final int order;

	// 요청 정보가 담긴 ServerWebExchange를 입력받아서 RouteDefinition의 predicates에 정의된 조건들에 매칭되는지를 검사
	private final AsyncPredicate<ServerWebExchange> predicate;

	private final List<GatewayFilter> gatewayFilters;

	private final Map<String, Object> metadata;

	// 생성자는 private으로 되어 있어, builder 로만 객체를 생성하도록 한다.
	private Route(String id, URI uri, int order,
			AsyncPredicate<ServerWebExchange> predicate,
			List<GatewayFilter> gatewayFilters, Map<String, Object> metadata) {
			// set 멤버변수 생략...
	}
	
	// 생략...

}
```

### Builder

- Route 는 Builder, AsyncBuilder 두 가지 빌더로 객체 생성 방법을 제공
- Builder, AsyncBuilder 두 객체 모두 AbstractBuilder 를 확장
- 두 빌더는 predicate 멤버변수의 타입 차이. 
  - Builder: `java.util.function.Predicate`, 입력 타입이 Generic 인 T이고 반환 타입이 Boolean인 함수형 인터페이스.
  - AsyncBuilder: `org.springframework.cloud.gateway.handler.AsyncPredicate`, 입력 타입이 Generic 인 T이고, 반환 타입이 Webflux의 Publisher(Mono, Flux)로 감싸진 Boolean (`Function<T, Publisher<Boolean>>`) 
- 아래 코드에도 나타나있지만, 결국 build 로 Route 객체를 생성 할 때는 모두 AsyncPredicate

```java
public abstract static class AbstractBuilder<B extends AbstractBuilder<B>> {
	
	// ... predicate 를 제외한 Route와 동일한 멤버 변수들과 그 멤버변수에 넣을 수 있는 메서드들 제공
	
	public Route build() {
		Assert.notNull(this.id, "id can not be null");
		Assert.notNull(this.uri, "uri can not be null");
		// Builder로 만들어도 결국 build 할 때는 AsyncPredicate로 변환된다.
		AsyncPredicate<ServerWebExchange> predicate = getPredicate();
		Assert.notNull(predicate, "predicate can not be null");

		return new Route(this.id, this.uri, this.order, predicate,
				this.gatewayFilters, this.metadata);
	}
}

public static class AsyncBuilder extends AbstractBuilder<AsyncBuilder> {

		protected AsyncPredicate<ServerWebExchange> predicate;
		
}

public static class Builder extends AbstractBuilder<Builder> {

		protected Predicate<ServerWebExchange> predicate; 
}
```

### metadata

- `Map<String, Object>` 객체로 되어 있어서, 비즈니스 로직에 필요한 정보들을 가질 수 있음
- `application.yml` 기반 metadata 설정 ([출처-Spring Cloud Gateway Docs > 11. Route Metadata Configuration](https://cloud.spring.io/spring-cloud-gateway/reference/html/#configuring-route-predicate-factories-and-gateway-filter-factories))

```yaml
spring:
  cloud:
    gateway:
      routes:
      - id: route_with_metadata
        uri: https://example.org
        metadata:
          optionName: "OptionValue"
          compositeObject:
            name: "value"
          iAmNumber: 1
```

- 요청 시점에 요청 정보를 가지고 있는 ServerWebExchange로부터 Route 객체를 가져와서 metadata에 접근 가능

```java
Route route = exchange.getAttribute(GATEWAY_ROUTE_ATTR);
route.getMetadata();
// key에 해당하는 Object를 가져와서 사용한다. 
// 위의 설정에서 가져올 수 있는 키들은 optionName, compositeObject, iAmNumber 등이 존재
route.getMetadata(someKey);
```