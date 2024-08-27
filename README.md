# MoodShop 

<img src= "https://github.com/user-attachments/assets/8fe4a12f-0d7e-410a-86a1-715ded890615">

## 앱의 기능

- 인기있는 상품 카테고리 별로 홈에서 확인할 수 있습니다.
- 관심있는 상품을 담고 관련된 상품들을 살펴볼 수 있습니다.
- 상품을 검색후 유저의 필터에 맞게 상품들을 볼 수 있습니다.
- 디테일 상품 화면에서 구매 및 유사한 제품들을 볼 수 있습니다.

| 홈 | 검색 | 좋아요 |
|:---:|:---:|:---:|
|<picture><img src="https://github.com/user-attachments/assets/45a770b9-b7fb-4972-b2ae-b024a64db561" width="200" height="440"/></picture>| <picture><img src="https://github.com/user-attachments/assets/81519e46-6a63-4a6c-a1e7-8149d816d934" width="200" height="440"/></picture>|<picture><img src="https://github.com/user-attachments/assets/7d28e433-29f3-4240-b45f-534050fc62fd" width="200" height="440"/></picture>|

| 상세 페이지 | 상품 구매 | 
|:---:|:---:|
|<picture><img src="https://github.com/user-attachments/assets/2afa9586-43ff-4ef8-bd94-58f5371560b4" width="200" height="440"/></picture>| <picture><img src="https://github.com/user-attachments/assets/bd47b86f-add7-4748-8807-03e4dc861631" width="200" height="440"/></picture>|

### 기술 스택

- SwiftUI, Combine
- Alamofire
- Realm
- MVI

# 기술설명

### SwiftUI + Combine
> iOS에서 제공하는 반응형 프로그래밍인 Combine프레임워크를 통해 비동기 데이터 스트림을 구현하였으며 Combine에서 제공되는 Future를 통해 Result타입으로 방출하여 스트림을 끊기지 않게 하였습니다.

```swift
func search(text: String, start: String, display: String) -> AnyPublisher<ShopModel, AppError> {
        
        return Future<ShopModel,AppError> { promise in
            Task {
                do {
                    let request = try Router.search.asURLRequest(text: text, start: start, display: display)
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    try checkResponse(data: data, response: response)
                    
                    try promise(.success(decodeModel(data: data, type: ShopModel.self)))
                    
                } catch {
                    print(error)
                    promise(.failure(.networkError(.unowned)))
                }
            }
        }
        .eraseToAnyPublisher()
        
    }
```

### MVI
> 단방향 데이터 흐름을 제공함으로써 상태(State)와 사용자 입력(Intent)의 명확하게 정의하여 디버깅시 흐름을 파악할 수 있습니다.<br>
프로토콜을 명시함으로써 유지보수를 유연하게 할 수 있게 설계하였습니다.


```swift
protocol ContainerProtocol {
    associatedtype Intent
    associatedtype State
    
    var state: State { get }
    
    func send(_ intent: Intent)
}

```

## 새롭게 적용해본 기술

### DTO, Entity
- DTO는 외부 서비스나 API로부터 받은 데이터를 나타냅니다
```swift
struct ShopModel: DTO {
    let total: Int
    ...
}
```

- Entity는 애플리케이션 내에서 실제로 사용되는 데이터를 표현함 이로써 각 계층의 책임이 명확히 나뉩니다.
```swift
struct ShopEntity: Entity {
    let total: Int
    ...
}


```
-  테스트 용이성의 이점
DTO와 Entity를 분리하면 각 계층의 로직을 독립적이므로 각 계층이 예상대로 작동하는지 확인할 수 있습니다.

### Mapper
  > Mapper 클래스를 통해 DTO를 Entity로 변환하는 과정을 중앙화하고, 이로 인해 데이터 변환 로직이 한 곳에 집중되어 재사용성과 유지보수성을 크게 향상시킵니다.
```swift
class HomeMapper {

    typealias Entity = ShopEntity
    typealias DTO = ShopModel
    
    func dtoToEntity(data: DTO) -> Entity {
        return ShopEntity(total: data.total, start: data.start, display: data.display, items: toShopItemEntity(data: data))
    }
    
}

```

### Repository
> 실제 데이터가 아닌 Entity 객체를 반환하므로, 테스트 시에도 Mapper를 활용한 변환 로직을 쉽게 검증할 수 있습니다.

```swift
final class HomeRepository {
    
    let mapper = HomeMapper()
    
    func fetchSearch(text: String, start: String = "1", display: String = "10") async -> AnyPublisher<ShopEntity, AppError> {
        
        return await NetworkManager.shared.search(text: text, start: start, display: display)
            .map { [weak self] result in
                guard let self else { return ShopEntity() }
                return mapper.dtoToEntity(data: result) }
            .eraseToAnyPublisher()
            
    }
}
```
## 고려한 사항

### Private(set) 순수함수 

> private(set)을 통해서 container의 State를 외부에서 직접적으로 수정하지 못하게 함으로써 순수함수와 유사하게 구성하였습니다.

```swift
final class HomeContainer: ObservableObject, ContainerProtocol {
    
    enum Intent {
        case onAppear
        ...
    }
    
    struct State {
        var text: String = ""
        ...
    }
    
    @Published
    private(set) var state: State = State()
    private var cancellables = Set<AnyCancellable>()
    
    private var homeRepository = HomeRepository()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            ...
        }
        
    }
}

```

### 버전 대응(Modifier(font) DynamicTextModifier)
>iOS 16.1 이상부터 제공되는 fontDesign 및 fontWeight을 사용하고 지원되지 않는 버전은 UIFontDescriptor을 사용해서 커스텀 폰트를 적용하였습니다.<br>
.setTextStyle 메서드를 사용하여 간단하고 직관적으로 텍스트 스타일을 지정할 수 있습니다
```swift
private struct DynamicTextModifier: ViewModifier {
    
    var size: CGFloat
    var design: Font.Design?
    var weight: Font.Weight?
    
    func body(content: Content) -> some View {
        if #available(iOS 16.1, *) {
            content
                .fontDesign(design)
                .fontWeight(weight)
                .font(.system(size: size))
        } else {
            content
                .font(.custom(customFontName(size: size, weight: weight, design: design), size: size))
        }
    }
    
    private func customFontName(size: CGFloat, weight: Font.Weight?, design: Font.Design?) -> String {
            var fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            
            if let weight = weight {
                switch weight {
                case .bold:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]])
                case .heavy:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.heavy]])
                ...
                }
            }
            
            if let design = design {
                switch design {
                case .serif:
                    fontDescriptor = fontDescriptor.withDesign(.serif) ?? fontDescriptor
                ...
                }
            }
            
            return UIFont(descriptor: fontDescriptor, size: size).fontName
        }

}

extension View {
    func setTextStyle(size: CGFloat, design: Font.Design?, weight: Font.Weight?) -> some View {
        modifier(DynamicTextModifier(size: size, design: design, weight: weight))
    }
}
```
