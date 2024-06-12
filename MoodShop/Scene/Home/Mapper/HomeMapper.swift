//
//  HomeMapper.swift
//  MoodShop
//
//  Created by 김진수 on 6/11/24.
//

import Foundation

class HomeMapper {
    
    func searchText (text: String, completionHandler: @escaping (Result<ShopEntity, Error>) -> Void) async {
        Task {
            await NetworkManager.shared.search(text: text) { [weak self] result in
                
                guard let self else { return }
                
                switch result {
                case .success(let data):
                    completionHandler(.success(transData(data: data)))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
                
            }
        }
    }
    
}

extension HomeMapper {
    
    private func transData(data: ShopModel) -> ShopEntity {
        
        var shopItemEntity: [ShopItemEntity] = []
        
        for item in data.items {
            shopItemEntity.append(ShopItemEntity(title: item.title, link: item.link, image: item.image, lprice: Int(item.lprice) ?? 0, mallName: item.mallName, productId: item.productId))
        }
        
        return ShopEntity(total: data.total, start: data.start, display: data.display, items: shopItemEntity)
    }
    
}
