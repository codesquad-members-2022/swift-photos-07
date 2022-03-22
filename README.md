# PhotoAlbum_7조

## 구성원
* 메이스
* 다마구찌-주스

## 협의 사항
```
<코어타임>
[10:30~12:30]
> 짝코딩

[14:00~14:15]
> 오후 스크럼(할일 목록회의)

[14:20~16:00]
> 짝코딩

[16:00~17:00]
> PR 작성

[18:00 ~ 22:00]
특이 사항시 모임, 그외 게더에서 모각코
```

# Step1 주요 구현 사항
## 구현 모습

![step1](https://user-images.githubusercontent.com/57667738/159431765-01361078-2320-48ee-b4dd-817291ee4a97.gif)

- [x] 뷰: Storyboard 에서 CollectionVeiw 생성
- [x] 모델: `Colors`, `ColorRange` 에서 컬러 모델 생성
- [x] 팩토리: `ColorFactory` 팩토리를 이용해 UIColor 를 ViewController 에 전달
- [x] 뷰컨트롤러 : `UICollectionViewDataSource` 를 extension 으로 설정
- [x] 테스트: 40개의 cell 에 들어갈 40개의 컬러가 생기는 지 테스트 ~~(UITest)~~

### 뷰: Storyboard 에서 CollectionVeiw 생성

* CollectionView 의 데이터 소스를 설정

https://user-images.githubusercontent.com/50472122/159459533-12a22d96-ddce-4e7c-a66f-9db2c845a6a7.mov

* cell size 조정 80 * 80

<img width="1440" alt="size" src="https://user-images.githubusercontent.com/50472122/159459296-3a0c40d0-0d68-44fb-ae25-b296fcfc7fc9.png">

* constraints 적용 

<img width="1552" alt="constraints" src="https://user-images.githubusercontent.com/50472122/159459315-cdf767c5-8d07-4f6e-94ce-90b92cc5a0f8.png">

### 모델: `Colors`, `ColorRange` 에서 컬러 모델 생성

* `color.swift`

```
struct Color {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

```

* `ColorRange.swift`

```
enum ColorRange {
    static let lower = 0.0
    static let upper = 1.0
    static let defaultAlpha = 1.0
}
```

- 숫자를 직접 사용하기보다는 의미있는 값으로 선언해서 사용하려 시도
- `upper` 를 255.0 으로 했다가 오류가 나서 고침


### 팩토리: `ColorFactory` 팩토리를 이용해 UIColor 를 ViewController 에 전달

```
struct ColorFactory {
    private static func generateRandom() -> UIColor {
        let red = Double.random(in: ColorRange.lower...ColorRange.upper)
        let green = Double.random(in: ColorRange.lower...ColorRange.upper)
        let blue = Double.random(in: ColorRange.lower...ColorRange.upper)
        let alpha = ColorRange.defaultAlpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func generateRandom(count: Int) -> [UIColor] {
        var colors: [UIColor] = []
        (0..<count).forEach { _ in
            colors.append(ColorFactory.generateRandom())
        }
        return colors
    }
}

```

- 내부에서만 사용하는 함수에 `private`을 붙임
- 매개 변수만 바꿔서 동일한 이름의 함수 선언


### 뷰컨트롤러 : `UICollectionViewDataSource` 를 extension 으로 설정

* ViewController.swift

```
...
    private let colors = ColorFactory.generateRandom(count: 40)
...

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = colors[indexPath.item]
        return cell
    }
}
```

- UICollectionViewDataSource 를 채택하고 선언해도 fix 해도 함수가 자동 완성으로 나오질 않음
- `numberOfItemsInSection` : 이 매개변수를 지니고 있는 메서드는 하나의 섹션에 넣을 셀의 개수를 지정
- `cellForItemAt indexPath` : 이 매개변수를 지닌 메서드는 그 당해 셀에 어떤 것을 넣을지 결정함


### 테스트: 40개의 cell 에 들어갈 40개의 컬러가 생기는 지 테스트 ~~(UITest)~~

* [Test] PhotoAlbumAppTests

```
import XCTest
@testable import PhotoAlbumApp

class PhotoAlbumAppTests: XCTestCase {
    
    func testGenerateRandom() {
        //given
        let subject = ColorFactory.generateRandom(count:)
        
        //when
        let testCount = 40
        let guess = subject(testCount)
        
        //then
        XCTAssertEqual(guess.count, testCount)
    }
}
```

# 소감

* 메이스 : 
 
* 다마구찌-주스 : 좋은 짝을 만나서 많이 배우는 중이다. 생각하지 못한 부분을 메이스가 드라이빙을 해주거나 코딩하는 모습을 발견할 때마다 신기하다. 컨벤션이나 그런 것을 배워야겠다는 생각이 들었지만, 아마 실천을 미룰 것이다. 
