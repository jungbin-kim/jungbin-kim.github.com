---
layout: post
title: AWS lambda using scala based on Serverless framework
date: 2018-04-23 06:58:30 +0900
published: true
comments: true
type: post
categories: [AWS]
tags: [Scala, AWS, Lambda]
---

## Serverless framework 기반, scala로 AWS lambda 사용하기

[Serverless framework](https://serverless.com/)가 `scala`로 AWS lambda에 함수를 등록할 수 있다는 것을 알게됨.
template 프로젝트를 실제 AWS lambda에 배포해봄.

### Install
```sh
# Install serverless globally (on Node.js v9.3.0)
$ npm install serverless -g

# .. Make AWS IAM user and Get it's key, secret ..

# Set AWS credentials
$ sls config credentials --provider aws --key 액세스키ID --secret 비밀액세스키

# Make template project
$ sls create -t aws-scala-sbt -p {project path}
```

### AWS IAM User Setting
1. AWS IAM 사용자 만들기 (access key, secret key 가 나옴)
1. 그 사용자가 속해있는 그룹 만들기 (옵션)
1. 그룹에 권한을 부여 (그룹을 만들지 않았다면, 사용자에게 권한 부여)
    + AdministratorAccess 권한을 주지 않고, 직접 권한 범위를 설정 한다면, 잘 설정해야 에러 나지 않음. (뒤에 Error handling 참고)
	+ AWSLambdaFullAccess (AWS에서 제공해주는 `관리형 정책`에서 설정할 수 있음)
	+ `인라인 정책`에서 아래와 같은 Custom 권한 부여 
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1449904348000",
            "Effect": "Allow",
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStackResource",
                "cloudformation:ValidateTemplate",
                "cloudformation:UpdateStack",
                "cloudformation:DeleteStack",
                "iam:CreateRole",
                "iam:DeleteRolePolicy",
                "iam:PutRolePolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

내가 [참고한 예제](https://velopert.com/3549)에서는 모든 권한(AdministratorAccess)을 가지도록 설정함.
아래와 같은 주의사항이 있어서, 필요한 권한만 체크하여 적용.
> 권한 설정은 나중에 가서 실제로 사용하게 될, 필요한 부분만 체크하셔도 됩니다. 예: API Gateway 관련, Lambda 관련, CloudFormation 관련… 지금은 편의상 모든 권한을 주는 정책을 설정해주겠습니다. 

어떤 권한이 필요한지는 deploy 를 해보면서 에러를 보고 파악한 뒤 추가. 

### Setting & Run
- 설치한 뒤, Serverless config인 `serverless.yml`에서 지역만 서울 리전 `ap-northeast-2`으로 수정함.

- sbt로 scala 프로젝트 빌드. 
(build.sbt 파일에서 별다른 수정을 하지 않았다면, 
`{프로젝트 루트}/target/scala-2.12` 경로에 `hello.jar`이 생성)
```sh
$ sbt assembly
```

- 빌드된 jar 파일을 AWS에 업로드 
```sh
# Deploy on AWS
$ sls deploy -v
```

- 로컬에서 펑션 테스트
```sh
# Run local
$ sls invoke -f hello -l
```

### Error Handling
#### AWS IAM user 권한 설정 문제

처음에 실행 명령어 `sls deploy -v`에 반복적으로 다음과 같은 에러가 발생함.
```sh
An error occurred: IamRoleLambdaExecution - crawler-imported-food-dev-ap-northeast-2-lambdaRole already exists.
```

*결론적으론 권한 문제였음.*

`crawler-imported-food-dev-ap-northeast-2-lambdaRole` 이런 이름을 가진 IAM Role을 직접 만든 적은 없음.
그래서, AWS > IAM > Role 메뉴에 들어가 무엇이 있는지 찾아봄.
`crawler-imported-food-dev-ap-northeast-2-lambdaRole`라는 Role이 만들어진 것을 확인.
이 Role은 `Serverless framework`가 배포를 진행할 때 순서와 관계가 있는 것 같았음.
- 배포를 위해 CloudFormation template을 만듬
- S3 bucket을 만들고, template과 jar 파일을 업로드
- CloudFormation template에 따라 lambda function을 만들어줌. 
    + 이 과정에서 lambda function의 Role을 만들고, 수정함.
    + 따라서, 사용자는 IAM Role을 생성, 수정 권한이 필요. 나중에 삭제를 위해서는 삭제 권한도 필요.
    + 그런데 이 과정을 할 수 있는 권한이 사용자에게 부여되어 있지 않았음. 
    그래서 `"iam:CreateRole","iam:DeleteRolePolicy","iam:PutRolePolicy"`을 추가해줌.

deploy 명령을 수행할 때 자신이 가지고 있는 IAM 사용자 권한에 따라 행동할 수 있는 반경이 제한됨.

#### 자바 Lambda local 실행시 에러
- local 함수 실행시 에러나는 문제 발생

```sh
$ sls invoke local -f hello
Serverless: Building Java bridge, first invocation might take a bit longer.
events.js:136
      throw er; // Unhandled 'error' event
      ^

Error: spawn mvn ENOENT
...
```

- 위의 문제는 자바 lambda에서도 발생한다는 리포트와 해결 방법에 대한 [Issue](https://github.com/serverless/serverless/issues/4789)를 발견.
여기에 나와 있는대로 우선 AWS에 배포한 후, 다음 local 실행 명령어를 실행함으로 해결.

```sh
$ serverless invoke -f hello -l
{
    "message": "Go Serverless v1.0! Your function executed successfully!",
    "request": {
        "key1": "",
        "key2": "",
        "key3": ""
    }
}
```