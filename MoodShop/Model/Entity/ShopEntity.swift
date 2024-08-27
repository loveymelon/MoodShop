//
//  ShopEntity.swift
//  MoodShop
//
//  Created by 김진수 on 6/11/24.
//

import Foundation

// Entity : 외부의 의존성을 줄이기 위해서 사용
// 만약 DTO하나만 쓴다고 할때 서버에서 Int를 주다가 String변경하게 되면 DTO를 그대로 쓰고 있는 모든 뷰에 접근해서 수정해야된다.
// 그래서 Entity를 사용함으로써 외부의 의존성을 낮춘 것이다.

// DTO는 그 역할만 하면 되는데 앱 내에 모델처럼 사용하면 그 역할이 명확해지지 않는다. 그래서 Entity를 사용
struct ShopEntity: Entity {
    let total: Int
    let start: Int
    let display: Int
    let items: [ShopItemEntity]
    
    init(total: Int = 0, start: Int = 0, display: Int = 0, items: [ShopItemEntity] = []) {
        self.total = total
        self.start = start
        self.display = display
        self.items = items
    }
}

struct ShopItemEntity: Entity, Hashable {
    let title: String
    let link: String
    let image: URL?
    let lprice: Int
    let mallName: String
    let productId: String
}
