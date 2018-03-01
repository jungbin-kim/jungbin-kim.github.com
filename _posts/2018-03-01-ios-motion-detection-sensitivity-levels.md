---
layout: post
title: Controls motion detection sensitivity levels on iOS
date: 2018-03-01 15:42:16 +0900
type: post
published: true
comments: true
categories: [iOS, Swift3]
tags: [iOS, Swift3, Sensor]
---

## iOS motion sensor 민감도 조절 방법 조사
디바이스 센서 데이터와 같이 지속적으로 업데이트되는 값은 들어오는 값 그대로(raw data)를 사용하는 것은 성능에 좋지 않을 수 있다.
데이터가 업데이트되는 주기가 빠를수록 그 데이터를 이용해야하는 함수 호출 또는 UI 렌더링 등이 그 빠르기로 실행된다.
따라서 요구사항에 따라 업데이트 주기를 조절하거나, 버퍼를 만드는 등 시간 관련 조절 방법을 적용할 수 있으며,
또는 어느 정도 값 이상에서만 반응하도록 만들수도 있다(ex: 디바이스가 어느정도 빠르기 이상의 움직임을 보일 때 비즈니스 로직 실행).


### Handling motion sensor data on iOS: CMMotionManager
> Use a CMMotionManager object to start the services that report movement detected by the device's onboard sensors. Use this object to receive four types of motion data:

from [Apple Developer 사이트](https://developer.apple.com/documentation/coremotion/cmmotionmanager)

CMMotionManager 객체에서 받는 motion data 의 4가지
- Accelerometer data 
- Gyroscope data
- Magnetometer data
- Device-motion data

#### Device-motion data
위 4가지 데이터 중에서 Device-motion data 데이터를 다루는 방법은 아래와 같음.

- *`deviceMotionUpdateInterval 변수`*

    CMMotionManager 객체는 motion data 를 받는 주기를 설정할 수 있는 변수인 
    [deviceMotionUpdateInterval](https://developer.apple.com/documentation/coremotion/cmmotionmanager/1616065-devicemotionupdateinterval)
    을 제공.
 
    ```swift
    let motionManager = CMMotionManager()
    let UPDATE_INTERVAL = 1.0 / 60.0 // 1초에 60번 업데이트
    motionManager.deviceMotionUpdateInterval = UPDATE_INTERVAL
    ```

- *`startDeviceMotionUpdates 함수`*

    motion data 가 업데이트 되었을 경우, 행동을 정의할 수 있는 함수.
    [startDeviceMotionUpdates(using:to:withHandler:)](https://developer.apple.com/documentation/coremotion/cmmotionmanager/1616176-startdevicemotionupdates)
    
    ```swift
    motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: OperationQueue.current!, withHandler: { deviceManager, error in
        if let manager = deviceManager {
            let userAcceleration = manager.userAcceleration
            // 민감도 설정 부분: x, y, z 축으로 어느정도 이상 움직여야 비즈니스 로직 진행되는 조건 적용
            if (fabs(userAcceleration.x) > 0.01
                || fabs(userAcceleration.y) > 0.01
                || fabs(userAcceleration.z) > 0.01) {
                // @TODO Apply business logic
            }
        }
    })
    ```

- *`Input parameters`*
    + using: motion data 의 x, y, z 축을 정의하기 위한 [Reference Frame](https://en.wikipedia.org/wiki/Frame_of_reference). Enum 값. 
    + to: 이 파라미터 정의된 queue 로 업데이트 명령을 보내는 것 같음.  
    + withHandler: 업데이트되는 motion data 를 처리하기 위한 callback 함수.

### 기타 참고
- https://medium.com/ios-os-x-development/motionkit-the-missing-ios-coremotion-wrapper-written-in-swift-99fcb83355d0
- http://www.mikitamanko.com/blog/2017/06/02/swift-get-values-from-accelerometer-and-gyroscope-via-cmmotionmanager/
- https://stackoverflow.com/questions/45890060/removing-the-effects-of-the-gravity-on-ios-iphone-accelerometer
