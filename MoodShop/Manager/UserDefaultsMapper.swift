//
//  UserDefaultsMapper.swift
//  MoodShop
//
//  Created by 김진수 on 7/4/24.
//

import Foundation

struct UserDefaultsMapper {
    
    typealias Entity = ShopItemEntity
    typealias DTO = ShopItem
    
    func dtoToEntity(data: DTO) -> Entity {
        let imageURL = URL(string: data.image)
        let price = Int(data.lprice) ?? 0
        
        return ShopItemEntity(title: data.title, link: data.link, image: imageURL, lprice: price, mallName: data.mallName, productId: data.productId)
    }
    
    func toShopItemEntity(data: Entity) -> DTO {
        
        return ShopItem(title: data.title, link: data.link, image: data.image?.absoluteString ?? "", lprice: String(data.lprice), mallName: data.mallName, productId: data.productId)
         
    }
    
}
