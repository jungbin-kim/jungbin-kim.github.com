---
layout: post
title: Heroku에 SpringBoot App을 무료로 배포해보자
date: 2019-03-02 12:44:00 +0900
published: true
comments: true
categories: [Service]
tags: [Spring boot, Heroku]
---

## Heroku에 SpringBoot App을 무료로 배포해보자
개인적으로 공부한 내용이나 하드웨어 리소스가 많이 필요하지 않은 간단한 백엔드 서비스를 개발하고 배포해보고 싶었음. 개인 서버나 클라우드 서버스를 사용하면 되지만 비용이 발생함. 초기에 무료로 사용할 수 있는 서비스가 있는지 찾아보다 [Heroku](https://www.heroku.com/)를 찾음.

**Free [Price Plan](https://www.heroku.com/pricing):**
- 30분 간 아무런 활동(web traffic)이 없으면 Sleep 
- CUSTOM DOMAINS 사용 가능
- 한달에 총 550 Dyno Hours 사용 가능
  - 신용카드 등록시, 450 시간 추가되어 1000 시간
  - [Free Dyno Hours](https://devcenter.heroku.com/articles/free-dyno-hours)에 관한 글
- 512 MB RAM │ 1 web/1 worker

본문은 [Deploying Spring Boot Applications to Heroku](https://devcenter.heroku.com/articles/deploying-spring-boot-apps-to-heroku)을 따라서 실행한 내용이다.

## 환경 설정
### Heroku CLI
- Install heroku CLI on macOS (brew 사용)
```sh
$ brew tap heroku/brew && brew install heroku
```

- Heroku CLI auto-complete 설정
  ```sh
  $ heroku autocomplete
  # ... 웹 로그인 heroku

  # zshrc 사용 경우, 설정
  $ printf "$(heroku autocomplete:script zsh)" >> ~/.zshrc
  $ source ~/.zshrc
  $ compaudit -D
  ```

- Heroku CLI 로그인 명령어를 사용하면 웹에서 로그인할 수 있게 창이 열린다.
```sh
$ heroku login
```

- 클라이언트(Mac)의 public key를 등록. (key를 만드는 방법은 [다음 문서](https://devcenter.heroku.com/articles/keys) 참고하여 생성.)
```sh 
$ heroku keys:add
Found an SSH public key at /file/path/
```

### SpringBoot CLI로 SpringBoot 프로젝트 생성
- Homebrew로 CLI를 설치. ([SpringBoot Docs](https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started-installing-spring-boot.html#getting-started-homebrew-cli-installation) 참조)
```sh
$ brew tap pivotal/tap
$ brew install springboot
```

- SpringBoot CLI로 SpringBoot Project 생성
```sh
# 현재 위치에 springboot-study 이름의 폴더 내에 springboot 프로젝트 생성
$ spring init --dependencies=web springboot-study
```

- (옵션) SpringBoot 어플리케이션에 잘 접근하는지 테스트하기 위한 end-point 추가 (`src/main/java/com/example/springbootstudy/DemoApplication.java`를 수정)
```java
@Controller
@SpringBootApplication
public class DemoApplication {
	@RequestMapping("/")
	@ResponseBody
	String home() {
		return "Hello World!";
	}

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
}
```

### Heroku App 생성
Deploy 하기 위해서 새로운 Heroku app 을 만든다.
```sh
$ heroku create
Creating app... done, safe-woodland-66362
https://safe-woodland-66362.herokuapp.com/ | https://git.heroku.com/safe-woodland-66362.git
```
- 접근할 수 있는 URL(위의 `https://safe-woodland-66362.herokuapp.com/`)이 생성됨. sub-domain 이름은 random generate이고, 나중에 `heroku apps:rename` 명령어로 이름변경 가능.
- 배포할 코드의 git remote repository `heroku`(위의 `https://git.heroku.com/safe-woodland-66362.git`)가 생성됨.


## Deploy
```sh
$ git push heroku master
```
- 기본적으로는 Java 8으로 세팅됨. (필요시, [다른 자바버전 세팅 방법](https://devcenter.heroku.com/articles/java-support#specifying-a-java-version) 참고)

### 기타
- 설정된 app의 URL이 브라우저에서 열림.
```sh
$ heroku open
```

- 앱 로그 보기
```sh
$ heroku logs --tail
```

- 사용량 보기
```sh
$ heroku ps
Free dyno hours quota remaining this month: 550h 0m (100%)
Free dyno usage for this app: 0h 0m (0%)
```
