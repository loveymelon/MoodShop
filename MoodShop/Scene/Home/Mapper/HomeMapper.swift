//
//  HomeMapper.swift
//  MoodShop
//
//  Created by 김진수 on 6/11/24.
//

import Foundation

class HomeMapper: MapperProtocol {

    typealias Entity = ShopEntity
    typealias DTO = ShopModel
    
    func dtoToEntity(data: DTO, categoryType: CategoryEnum) -> Entity {
        return ShopEntity(total: data.total, start: data.start, display: data.display, items: toShopItemEntity(data: data, categoryType: categoryType))
    }
    
}

// 하나의 함수에서 하나 일만 담당하기 위해서 따로 뺐다.
// ShopModel을 받으면 내부에 있는 배열을 client가 원하는 타입으로 변경하여 사용하고 있다.
extension HomeMapper {
    private func toShopItemEntity(data: DTO, categoryType: CategoryEnum) -> [ShopItemEntity] {
        return data.items.map { datas in
            let imageUrl = URL(string: datas.image)
            
            return ShopItemEntity(title: datas.title, link: datas.link, image: imageUrl, lprice: Int(datas.lprice) ?? 0, mallName: datas.mallName, productId: datas.productId, categoryType: categoryType)
        }
    }
}
