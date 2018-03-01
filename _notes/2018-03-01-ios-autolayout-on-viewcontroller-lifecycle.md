---
layout: post
title: When auto layout apply to UI on view controller's life cycle
date: 2018-03-01 21:45:39 +0900
published: true
comments: true
categories: [iOS]
tags: [iOS, UI, Life Cycle]
---

## UIViewController life cycle 중, storyboard 에서 설정한 auto layout 적용 시점
UIView 에 dashed & rounded border 를 적용하기 위해 `viewDidLoad()` 와 
`viewWillAppear()` 에 아래 `applyDashedRoundBorder(view: UIView)` 함수를 실행.
하지만, Auto layout 이 적용되지 않고 storyboard 에서 설정한 값으로 width, height 가 적용됨.
즉, Storyboard 작업 시에는 iPhone8, 실제 테스트 기기는 iPhone7+ 였을 때 
iPhone8 용으로 설정한 width, height 로 border 가 예상보다 작게 그려짐.   

```swift

override func viewDidLoad() {
    super.viewDidLoad()
    // applyDashedRoundBorder ??
}
    
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // applyDashedRoundBorder ??
}

override func viewDidLayoutSubviews() { 
    // applyDashedRoundBorder ??
}

func applyDashedRoundBorder(view: UIView) {
    let border = CAShapeLayer()
    border.strokeColor = .black
    border.lineWidth = 1 // border 굵기
    border.fillColor = nil // 없으면 black으로 채워짐.
    border.lineDashPattern = [4, 4]
    border.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8).cgPath 
    border.frame = view.bounds
    view.layer.addSublayer(border)
}
```

그래서 `viewDidLoad()`에서 view 의 frame 을 찍어보니, storyboard 에서 정한 frame 임과 같은 것을 확인.
 반면, `viewDidLayoutSubviews()`에서는 auto layout 이 적용된 frame 으로 나옴.
 
[When Should You Override viewDidLayoutSubviews?](http://www.iosinsight.com/override-viewdidlayoutsubviews/) 에서는
아래와 같은 이유로 `viewDidLayoutSubviews()` 함수를 사용한다고 한다. 
> the frame and bounds for a view are not finalized until Auto Layout has done its job of laying out the main view and subviews.

main view와 subviews를 우선 배치한 뒤에 auto layout이 view의 frame과 bounds에 적용되기 때문에, 
`viewDidLoad()`와 `viewWillAppear()`에서는 view 가 storyboard에 정의된대로 나오며,
 그 뒤에 호출되는 생성주기 함수부터는 auto layout이 적용된 상태로 나오게 됨.

또한, `viewDidLayoutSubviews()`를 사용함에 있어 조심해야할 것은 [여러 가지 이유](https://stackoverflow.com/a/36417553)로 여러번 호출될 수 있기 때문에
고려해서 사용해야함.

### 참고
- [viewDidLoad에서 frame 사이즈 안잡힘](https://stackoverflow.com/a/37726043) 
- [UIBezierPath에서 roundedRect으로 설정해야 rounded 설정이 먹힘](https://stackoverflow.com/questions/35053805/how-to-give-cornerradius-for-uibezierpath)
- [Apple Developer Docs viewwilllayoutsubviews](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621437-viewwilllayoutsubviews)