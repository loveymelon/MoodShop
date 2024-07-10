//
//  DetailMapper.swift
//  MoodShop
//
//  Created by 김진수 on 7/9/24.
//

import Foundation

final class DetailMapper {
    
    typealias Entity = ShopItemEntity
    typealias DTO = ShopItemRequestDTO
    
    func entityToDTO(_ entity: Entity) -> DTO {
        let imageURL = entity.image?.absoluteString ?? ""
        let title = entity.title.rmHTMLTag
        
        return ShopItemRequestDTO(title: title, link: entity.link, image: imageURL, lprice: entity.lprice, mallName: entity.mallName, productId: entity.productId)
    }
    
    func dtoToEntity(_ dto: DTO) -> Entity {
        let imageURL = URL(string: dto.image)
        
        return ShopItemEntity(title: dto.title, link: dto.link, image: imageURL, lprice: dto.lprice, mallName: dto.mallName, productId: dto.productId)
    }
    
}
