//
//  ShopItemRequestDTO.swift
//  MoodShop
//
//  Created by 김진수 on 7/5/24.
//

import Foundation
import RealmSwift

class ShopItemRequestDTO: Object {
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var lprice: Int
    @Persisted var mallName: String
    @Persisted var productId: String
    
    convenience init(id: String, title: String, link: String, image: String, lprice: Int, mallName: String, productId: String) {
        self.init()
        
        self.id = id
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.productId = productId
    }
}
