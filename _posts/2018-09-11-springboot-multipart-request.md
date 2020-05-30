---
layout: post
title: Handling Multipart/form-data on Spring Boot 2
date: 2018-09-11 23:29:49 +0900
published: true
comments: true
categories: [Spring]
tags: [Spring Boot]
type: note
---

## content-type이 multipart/form-data 인 HTTP Request를 Spring Boot 2에서 처리하는 방법

`build.gradle`에 spring-boot-starter-web 디펜던시 추가
```gradle
dependencies {
	compile('org.springframework.boot:spring-boot-starter-web')
}
```
Maven의 경우, `pom.xml` 에 디펜던시 추가
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>1.5.10.RELEASE</version>
</dependency>
```
Controller 부분에는 다음과 같이 작성.
```java
@RequestMapping(path = "/files", method = RequestMethod.POST,
        consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
public @ResponseBody ResponseEntity<String> add(@RequestParam("file") MultipartFile file) {
    System.out.println(file.getOriginalFilename());
    return new ResponseEntity<>("Created", HttpStatus.OK);
}
```


## File 외에 다른 파라미터들이 함께 있을 때
**1번:** 아래 코드와 같이 Request path 와 매핑되는 함수의 입력 파라미터를 추가
```java
@RequestMapping(path = "/files", method = RequestMethod.POST,
        consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
public @ResponseBody ResponseEntity<String> add(
        @RequestParam("file") MultipartFile file,
        @RequestParam("name") String name, @RequestParam("brand") String brand) {
    System.out.println(file.getOriginalFilename() + "\n" + name + "\n" + brand);
    return new ResponseEntity<>("Created", HttpStatus.OK);
}
```
{% include figure_with_caption.html
   url='/img/posts/2018-09-11-springboot2-mutipart.png'
   title='Swagger UI'
   width='70%' %}

**2번:** 많은 입력 파라미터들이 있을 때는 Model Class를 만들고, `@ModelAttribute` annotation을 사용.
```java
// lombok annotation 사용. 직접 Getter, Setter 만들어도 됨.
@Getter @Setter
public class MultiPartsRequestPayload {
    private String name;
    private String brand;
    private MultipartFile file;
}

@RequestMapping(path = "/files", method = RequestMethod.POST,
        consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
public @ResponseBody ResponseEntity<String> add(
        @ModelAttribute("multiPartsRequestPayload") MultiPartsRequestPayload multiPartsRequestPayload
        ) {
    System.out.println(multiPartsRequestPayload.getFile().getOriginalFilename() + "\n" + multiPartsRequestPayload.getName() + "\n" + multiPartsRequestPayload.getBrand());
    return new ResponseEntity<>("Created", HttpStatus.OK);
}
```

두번째 경우에는 **Controller 함수의 입력 파라미터들을 각각 관리하지 않고, Model Class 에서 validation 설정을 할 수 있다는 장점**이 있음.
대신 Swagger ui(`springfox-swagger-ui:2.9.2`) 상에서 file을 제대로 선택할 수 없는 이슈가 존재.
{% include figure_with_caption.html
   url='/img/posts/2018-09-11-springboot2-mutipart2.png'
   title='Swagger UI에서 file 선택 불가'
   width='70%' %}

## 참조
- [File Upload with Spring MVC](https://www.baeldung.com/spring-file-upload)
