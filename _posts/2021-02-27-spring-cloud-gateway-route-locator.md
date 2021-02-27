---
layout: post
title: Spring Cloud Gateway RouteDefinitionLocator & RouteLocator 코드 분석
date: 2021-02-27 21:00:00 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring, Spring Cloud Gateway]
type: note
---

## Spring Cloud Gateway RouteDefinitionLocator & RouteLocator 코드 분석
Spring Cloud Gateway에서 Java DSL(Domain-Specific Languages)로 정의된 Route 객체들과 설정 파일에서 정의한 route 정보들을 어떻게 메모리에 가지고 있는지를 `RouteDefinitionLocator`, `RouteLocator` 객체를 통해 알아본다.
<br>
Java DSL 방식은 별도의 RouteLocator Bean 을 정의하고, 그 내부에 route 정보를 작성한다. 
<br>
application.yml 과 같은 설정 파일에서 정의된 route 정보 같은 경우, RouteDefinition 객체로 역직렬화한 뒤 RouteDefinitionRouteLocator 에서 Route 객체로 변경된다.
<br>
위에서 언급된 RouteLocator Bean 들은 하나로 합쳐지며 캐싱된다. (CompositeRouteLocator, CachingRouteLocator) 
<br>
캐싱된 Route 객체들을 가지고 있는 RouteLocator Bean 은 [이전 글 - Spring Cloud Gateway Web Handler 코드 분석](/spring/2021/02/20/spring-cloud-gateway-web-handler.html)에서 살펴본  RoutePredicateHandlerMapping 에 주입되어 클라이언트 요청과 매핑하는데 사용된다.

## RouteDefinitionLocator

```java
public interface RouteDefinitionLocator {
	Flux<RouteDefinition> getRouteDefinitions();
}
```

- Flux 형태로 RouteDefinition 객체들을 반환하는 메서드를 구현하도록 하는 규약
- Spring Cloud Gateway에서 RouteDefinitionLocator의 구현체는 `PropertiesRouteDefinitionLocator`, `InMemoryRouteDefinitionRepository`, `CompositeRouteDefinitionLocator`, `DiscoveryClientRouteDefinitionLocator`, `CachingRouteDefinitionLocator` 들이 존재
  - CachingRouteDefinitionLocator: 현재 버전에서는 테스트 코드에서만 사용됨.
  - DiscoveryClientRouteDefinitionLocator: Eureka 나 Consul 같은 Service Discovery 와 연동하여 등록된 서비스들을 가져와서 로드밸런싱 등에 이용
    - 참고: [Spring Cloud Gateway 문서](https://cloud.spring.io/spring-cloud-gateway/reference/html/#the-discoveryclient-route-definition-locator), [Spring Cloud DiscoveryClient Support - Baeldung](https://www.baeldung.com/spring-cloud-gateway#spring-cloud-discoveryclient-support)
- 아래 그림과 같이 CompositeRouteDefinitionLocator Bean에서 하나의  `Flux<RouteDefinition>` 합쳐지는 구조

![](/img/posts/2021-02-27-spring_cloud_gateway_routedefinitionlocator.png)

### PropertiesRouteDefinitionLocator

- `application.yml` >  `spring.cloud.gateway.routes`에 정의되어 있는 route 정보들을 제공하는 메서드 존재

```java
// 생성자
public PropertiesRouteDefinitionLocator(GatewayProperties properties) {
	// 설정 객체인 GatewayProperties을 주입받는다.
	this.properties = properties;
}

@Override
public Flux<RouteDefinition> getRouteDefinitions() {
	// 설정 객체에 있는 route 정보를 반환
	return Flux.fromIterable(this.properties.getRoutes());
}
```

#### GatewayProperties

- 위치: `org.springframework.cloud.gateway.config.GatewayProperties`
- `application.yml`의  `spring.cloud.gateway` prefix로 갖는 설정 구현 객체


### InMemoryRouteDefinitionRepository

- RouteDefinitionLocator, RouteDefinitionWriter를 확장한 RouteDefinitionRepository 를 구현

```java
// in-memory RouteDefinition 저장 멤버변수
private final Map<String, RouteDefinition> routes = synchronizedMap(new LinkedHashMap<String, RouteDefinition>());

@Override
public Flux<RouteDefinition> getRouteDefinitions() {
	// 저장되어 있는 RouteDefinition 반환
	return Flux.fromIterable(routes.values());
}
```

#### RouteDefinitionWriter

- RouteDefinition 객체를 받아서 저장하는 save 메서드와 routeId로 해당 RouteDefinition를 지우는 delete 메서드를 구현하도록 함.

```java
public interface RouteDefinitionWriter {
	Mono<Void> save(Mono<RouteDefinition> route);
	Mono<Void> delete(Mono<String> routeId);
}
```

#### AbstractGatewayControllerEndpoint

- 위치: `org.springframework.cloud.gateway.actuate.AbstractGatewayControllerEndpoint`
- InMemoryRouteDefinitionRepository 에 저장되어 있는 RouteDefinition 객체를 수정할 수 있는 엔드포인트 존재
- RouteDefinitionWriter 객체를 주입 받아서 save, delete 메서드 사용

```java
@PostMapping("/routes/{id}")
public Mono<ResponseEntity<Object>> save(@PathVariable String id, @RequestBody RouteDefinition route)
@DeleteMapping("/routes/{id}")
public Mono<ResponseEntity<Object>> delete(@PathVariable String id)
```

### CompositeRouteDefinitionLocator

- 여러 개의 RouteDefinitionLocator 들을 delegates로 가지고, 각 RouteDefinitionLocator 들이 가지고 있는 RouteDefinition들을 하나로 합하며, RouteDefinition의 route Id 가 생략되어 있는 경우, random Id를 만듬

```java
// 생성자
public CompositeRouteDefinitionLocator(Flux<RouteDefinitionLocator> delegates, IdGenerator idGenerator) {
	this.delegates = delegates;
	this.idGenerator = idGenerator;
}

@Override
public Flux<RouteDefinition> getRouteDefinitions() {
	// 각 RouteDefinitionLocator의 RouteDefinition들을 하나로 합쳐준다.
	return this.delegates
			.flatMapSequential(RouteDefinitionLocator::getRouteDefinitions)
			.flatMap(routeDefinition -> {
				// route Id 가 없는 경우 randomId를 만들어준다.
				if (routeDefinition.getId() == null) {
					return randomId().map(id -> {
						routeDefinition.setId(id);
						if (log.isDebugEnabled()) {
							log.debug("Id set on route definition: " + routeDefinition);
						}
						return routeDefinition;
					});
				}
				return Mono.just(routeDefinition);
			});
}
```

## RouteLocator

```java
public interface RouteLocator {
	Flux<Route> getRoutes();
}
```

- Flux 형태로 Route 객체들을 반환하는 메서드를 구현하도록 하는 규약
- Spring Cloud Gateway에서 RouteLocator의 구현체는 RouteDefinitionRouteLocator, CompositeRouteLocator, CachingRouteLocator 들이 존재
- RoutePredicateHandlerMapping 에서 Route 들의 정보를 가져오기 위해서 Inject
  - RoutePredicateHandlerMapping 는 [이전 글 - Spring Cloud Gateway Web Handler 코드 분석](/spring/2021/02/20/spring-cloud-gateway-web-handler.html) 참고
- 아래 그림과 같이 CompositeRouteLocator Bean에서 하나의 `Flux<Route>` 합쳐지며, CachingRouteLocator Bean에서 캐시하는 구조
![](/img/posts/2021-02-27-spring_cloud_gateway_routelocator.png)

### RouteDefinitionRouteLocator

- RouteDefinitionLocator 으로부터 route들을 로드할 수 있는 RouteLocator

```java
private final Map<String, RoutePredicateFactory> predicates = new LinkedHashMap<>();

private final Map<String, GatewayFilterFactory> gatewayFilterFactories = new HashMap<>();

// 생성자
public RouteDefinitionRouteLocator(RouteDefinitionLocator routeDefinitionLocator,
    List<RoutePredicateFactory> predicates,
    List<GatewayFilterFactory> gatewayFilterFactories,
    GatewayProperties gatewayProperties,
    ConfigurationService configurationService) {
 this.routeDefinitionLocator = routeDefinitionLocator;
 this.configurationService = configurationService;
	// 주입받은 RoutePredicateFactory 들을 멤버변수 predicates 에 넣는다. key는 predicate 의 이름.
 initFactories(predicates);
	// 주입받은 GatewayFilterFactory 들을 멤버변수 gatewayFilterFactories 에 넣는다. key는 filter의 이름.
 gatewayFilterFactories.forEach(factory -> this.gatewayFilterFactories.put(factory.name(), factory));
 this.gatewayProperties = gatewayProperties;
}
```

- RoutePredicateFactory
  - 요청이 Route에 매칭되는지 검사하는 조건을 가진 Bean
  - `org.springframework.cloud.gateway.handler.predicate` 패키지 참고
- GatewayFilterFactory
  - 요청이 거쳐야하는 Filter Bean
  - `org.springframework.cloud.gateway.filter.factory` 패키지 참고

getRoutes 메서드:

```java
@Override
public Flux<Route> getRoutes() {
	// routeDefinitionLocator 에서 RouteDeinition들을 가져와서 Route 객체로 변환한다.
	Flux<Route> routes = this.routeDefinitionLocator.getRouteDefinitions()
			.map(this::convertToRoute);

	//... (생략) routes 변환 과정 에러 처리 

	// (생략) routes 디버그
	return routes;
}
```

### CompositeRouteLocator

- 여러 개의 RouteLocator 들을 delegates로 가지고, 각 RouteLocator 들이 가지고 있는 Route들을 하나로 합하는 기능 제공

```java
public class CompositeRouteLocator implements RouteLocator {

	private final Flux<RouteLocator> delegates;

	public CompositeRouteLocator(Flux<RouteLocator> delegates) {
		this.delegates = delegates;
	}

	@Override
	public Flux<Route> getRoutes() {
		// 각 RouteLocator의 Route들을 하나로 합쳐준다.
		return this.delegates.flatMapSequential(RouteLocator::getRoutes);
	}

}
```

- `GatewayAutoConfiguration` 에서 `List<RouteLocator>` 를 주입 받아서 하나의 RouteLocator (`CompositeRouteLocator`)로 만들어서 `CachingRouteLocator` 로 주입

```java
public RouteLocator cachedCompositeRouteLocator(List<RouteLocator> routeLocators) {
	return new CachingRouteLocator(
			new CompositeRouteLocator(Flux.fromIterable(routeLocators)));
}
```

### CachingRouteLocator

```java
public class CachingRouteLocator implements Ordered, RouteLocator,
		ApplicationListener<RefreshRoutesEvent>, ApplicationEventPublisherAware {
//...
}
```

생성자:

- 입력 받은 RouteLocator를 delegate로 가지고 있음.
- CacheFlux에 "routes" 라는 cache key에 매칭되는 값이 있으면,  해당 값을 멤버 변수로 저장. 없을 경우, delegate로 가지는 RouteLocator에서 `Flux<Route>` 를 가져와서 정렬하여 저장.

```java
private static final String CACHE_KEY = "routes";

public CachingRouteLocator(RouteLocator delegate) {
	this.delegate = delegate;
	routes = CacheFlux.lookup(cache, CACHE_KEY, Route.class)
			.onCacheMissResume(this::fetch);
}

private Flux<Route> fetch() {
	return this.delegate.getRoutes().sort(AnnotationAwareOrderComparator.INSTANCE);
}
```


onApplicationEvent 메서드:

- `ApplicationListener<RefreshRoutesEvent>` 를 구현하기 위한 Override 메서드
- RefreshRoutesEvent가 발생할 경우 delegate로 가지고 있는 RouteLocator에서 Flux<Route> 를 가져와 캐시 업데이트
  - materialize: 들어오는 onNext, onError 및 onComplete 과 같은 신호를 Signal 인스턴스로 변환

```java
@Override
public void onApplicationEvent(RefreshRoutesEvent event) {
	try {
		// delegate하고 있는 RouteLocator에서 Flux<Route> 를 가져와 Mono<List<Route>> 로 변경
		fetch().collect(Collectors.toList()).subscribe(list -> Flux.fromIterable(list)
				// 구독 후 Flux<Signal<Route>>로 변환된 상태에서 Mono<List<Signal<Route>>> 로 변환
				.materialize().collect(Collectors.toList()).subscribe(signals -> {
					applicationEventPublisher
							.publishEvent(new RefreshRoutesResultEvent(this));
					// List<Signal<Route>> 상태로 캐시 업데이트
					cache.put(CACHE_KEY, signals);
				}, throwable -> handleRefreshError(throwable)));
	}
	catch (Throwable e) {
		handleRefreshError(e);
	}
}
```

## 참고
- [Spring-Cloud-Gateway source code analysis-RouteDefinitionRepository storage of routing (1.3) - Programmer Sought](https://www.programmersought.com/article/68096265725/)