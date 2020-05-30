---
layout: post
title: Handling Garbage Collection log on Elasticsearch
date: 2018-10-27 20:01:23 +0900
published: true
comments: true
categories: [Elasticsearch]
tags: [Elasticsearch, Docker, ErrorHandling]
type: note
---

## Elasticsearch 에서 Garbage Collection log Option (Custom JVM Option) 적용
Elasticsearch 가 docker로 운영되고 있는 서버 인스턴스에서 Elasticsearch 의 `gc.log` 가 쌓여 디스크를 가득 차지하는 문제가 발생.
디스크가 가득찬 경우 서버 인스턴스에서 명령어를 실행할 수가 없음. 몇몇 파일을 삭제해서 조금의 용량을 확보하기 전까지는 docker 명령어 조차 실행하기 힘들었음.

## 원인 파악
처음에는 용량이 부족해진 것만 알고 정확한 이유에 대해서 몰랐기 때문에 해당 docker container 들을 다시 한번 돌린 후 container 내 변화를 관찰.
**관찰 이틀째** container 내 `log` 폴더에 아래와 같이 파일들이 만들어진 것을 확인. 그래서 `gc.log`가 서버 인스턴스의 디스크 용량을 초과할 때까지 쌓인 것으로 원인 파악함.

**관찰 이틀째 gc.log 용량:**
```
# 마스터 노드
total 87M
-rw-rw-r-- 1 elasticsearch root 865K Oct 24 01:20 gc.log
-rw-rw-r-- 1 elasticsearch root 855K Oct 22 01:44 gc.log.00
-rw-rw-r-- 1 elasticsearch root 2.5M Oct 22 02:18 gc.log.01
-rw-rw-r-- 1 elasticsearch root 1.5M Oct 22 02:36 gc.log.02
-rw-rw-r-- 1 elasticsearch root  30M Oct 22 15:10 gc.log.03
-rw-rw-r-- 1 elasticsearch root 2.0M Oct 22 15:41 gc.log.04
-rw-rw-r-- 1 elasticsearch root 1.2M Oct 22 16:00 gc.log.05
-rw-rw-r-- 1 elasticsearch root 1.3M Oct 22 16:18 gc.log.06
-rw-rw-r-- 1 elasticsearch root 1.2M Oct 22 16:35 gc.log.07
-rw-rw-r-- 1 elasticsearch root 1.4M Oct 22 16:53 gc.log.08
-rw-rw-r-- 1 elasticsearch root  42M Oct 24 00:13 gc.log.09
-rw-rw-r-- 1 elasticsearch root 1.1M Oct 24 00:29 gc.log.10
-rw-rw-r-- 1 elasticsearch root 1.7M Oct 24 00:55 gc.log.11
-rw-rw-r-- 1 elasticsearch root 1.1M Oct 24 01:11 gc.log.12
-rw-rw-r-- 1 elasticsearch root 114K Oct 22 02:18 hs_err_pid1.log

# 데이터 노드 1
total 56M
-rw-rw-r-- 1 elasticsearch root  55M Oct 24 01:19 gc.log
-rw-rw-r-- 1 elasticsearch root 695K Oct 22 01:44 gc.log.00

# 데이터 노드 2
total 141M
-rw-rw-r-- 1 elasticsearch root  12M Oct 24 01:19 gc.log
-rw-rw-r-- 1 elasticsearch root 1.1M Oct 22 01:44 gc.log.00
-rw-rw-r-- 1 elasticsearch root  65M Oct 22 21:17 gc.log.01
-rw-rw-r-- 1 elasticsearch root  65M Oct 23 21:27 gc.log.02
```

## 해결 방법 모색
Elasticsearch 의 `gc.log` 에 대해 [검색해본 결과](https://www.elastic.co/guide/en/elasticsearch/reference/6.x/gc-logging.html),
- 기본적으로 Elasticsearch 에서 GC logs를 사용 가능하게 하며 Elasticsearch log들과 같은 path에 저장.
- Default 옵션으로 로그가 `64MB` 씩 `32개`의 파일로 총 `2GB`의 디스크 용량을 차지하게 됨.

위의 내용을 기반으로 해결 방법들을 생각해봄.
- [기각] 서버 인스턴스의 디스크 용량 증가 => 데이터 노드까지 포함하여 6GB 이상의 여유 공간을 확보하면 됨 => GC log 가 현재로썬 그정도까지 중요하지 않음.
- [기각] 주기적으로 로그를 제거하는 `cron job` => 부가적인 작업 발생 및 log 옵션 설정만으로 해당 작업을 대체할 수 있을 것 같았음.
- **[진행 방법]** `gc.log` 관련 옵션 설정을 통해 `64MB`보다 더 작은 용량으로 `32개`보다 작은 수의 파일로 저장

## 적용
### [실패] docker-compose.yml 내 ES_JAVA_OPTS 설정
`docker-compose.yml` 내 [ES_JAVA_OPTS](https://github.com/jungbin-kim/docker-elk/blob/searchguard%2Bxpack/docker-compose.yml#L16) 에
JVM custom option 을 `ES_JAVA_OPTS: "-Xms512m -Xmx512m -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=20M"` 와 같이 넣어줌.
(참고: [Elatic 회사 GC log 문서](https://www.elastic.co/guide/en/elasticsearch/reference/6.2//_gc_logging.html),
[Rolling Java GC Logs](http://jesseyates.com/2012/11/05/rolling-java-gc-logs.html))

해당 옵션을 적용하고 docker container 를 시작할 때, jvm 에서 해당 옵션을 인식할 수 없다는 에러가 발생하며 실행되지 않음.

변경하지 않고 Elasticsearch 가 시작될 때의 나오는 로그들을 확인했을 때 위의 옵션들과는 다른 형식으로 설정되어 있음.

[Deprecated GC Logging Properties](https://dzone.com/articles/disruptive-changes-to-gc-logging-in-java-9)을 보니 최신 JVM(Java9 부터) 에서 바뀜.
그래서 바뀐 형식인 `ES_JAVA_OPTS: "-Xms512m -Xmx512m -Xlog:gc*,gc+age=trace,safepoint:file=logs/gc.log:utctime,pid,tags:filecount=5,filesize=20m"`으로 filecount와 filesize를 수정하여 적용.

실행 시 로그에서 JVM arguments 끝에 `ES_JAVA_OPTS`의 custom 설정이 들어가 있는 것을 확인.
하지만, `$ docker exec -it {elasticsearch container 이름} ps -awef` 로 적용된 jvm memory 옵션 확인 및 `gc.log`가 설정된대로 작동하지 않았음.

자바 어플리케이션을 시작할 때 설정하는 `jvm options`이 중복될 경우 오른쪽에 위치해있는 것으로 적용될 것으로 생각했지만 적용되지 않았음.
- [Duplicated Java runtime options : what is the order of preference?](https://stackoverflow.com/questions/2740725/duplicated-java-runtime-options-what-is-the-order-of-preference)의 답변은
`Don't do that`

### [성공] Custom jvm.options 파일로 ES 도커 이미지 빌드
Elasticsearch docker image build 할 때 수정된 `jvm.options` 파일을 넣어 빌드 실행. ([적용 코드](https://github.com/jungbin-kim/docker-elk/commit/ca1cf8750bece5cbbea7d387f742e1bddb58b8df))
- 원하는 옵션(`-Xms`, `-Xmx` 등)을 넣은 [jvm.options 파일](https://github.com/jungbin-kim/docker-elk/blob/searchguard%2Bxpack/elasticsearch/config/jvm.options)을 만듬
- [elasticsearch/Dockerfile 파일](https://github.com/jungbin-kim/docker-elk/blob/searchguard%2Bxpack/elasticsearch/Dockerfile) 내 `COPY config/jvm.options config/jvm.options`하여 원하는 옵션으로 Elasticsearch 이미지 빌드

## 참고
- Elasticsearch 노드 JVM Heap 설정 (출처: 일래스틱 스택6 입문, p391):
> -Xms, -Xmx 설정 값을 똑같이 설정.
Heap 메모리가 많다는 것은 Elasticsearch 가 대량의 데이터를 메모리에 저장하고 더 빠르게 접근할 수 있다는 것을 의미.
하지만, Heap 메모리가 가득 차면 JVM 가비지 컬렉터가 Full Garbage Collection을 실행하고, 이때 ES 노드의 모든 처리는 중지됨.
따라서 Heap 크기가 클수록 정지 시간도 늘어남. 설정할 수 있는 최대 Heap 크기는 약 32GB. 주의할 사항은 ES JVM에 총 메모리 기준 50%이상을 할당하지 말아야함.
아파치 루씬의 파일 시스템 캐시에 충분한 메모리가 필요하기 때문.
궁극적으로 ES 노드에 저장되는 모든 데이터는 아파치 루씬 인덱스로 관리되고, 해당 인덱스는 파일에 빠르게 접근하기 위해 메모리를 사용. 따라서 ES 에 대규모 데이터를 저장한다고 하더라도 단일 노드에 메모리 64GB 이상을 모두 활용할 수 없음.
64GB 메모리를 할당해도 50%인 32GB가 최대 Heap 메모리기 때문. 확장성이 필요하다면 노드를 추가하는 방법을 고려.

- Docker 사용하지 않고 서버 인스턴스에 서비스로 설치한 버전에서 발생한 디스크 용량 관련 에러 => 서버 인스턴스의 tmp 폴더 청소
Elasticsearch instance는 떠 있는데 갑자기 다음과 같은 에러 남
```js
HTTP/1.1 503 Service Unavailable
{
   "error":{
      "root_cause":[],
      "type":"search_phase_execution_exception",
      "reason":"all shards failed",
      "phase":"query",
      "grouped":true,
      "failed_shards":[]
   },
   "status":503
}
```
서비스를 재시작하면서 다음과 같은 에러 메시지
```
Java HotSpot(TM) 64-Bit Server VM warning: Insufficient space for shared memory file:
Try using the -Djava.io.tmpdir= option to select an alternate temp location.
```
[불필요한 파일을 지우라는 답글](https://okky.kr/article/230231)에 따라 불필요한 파일 삭제로 해결.

- GC log가 아닌 Elasticsearch의 로그 옵션은 [Elastic 사의 Elasticsearch 로그 옵션 관련 문서](https://www.elastic.co/guide/en/elasticsearch/reference/master/logging.html)를 보면
docker container 안 `/usr/share/elasticsearch/config` 에 `log4j2.properties` 파일에서 옵션 수정 필요.
