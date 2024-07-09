//
//  LikeRepository.swift
//  MoodShop
//
//  Created by 김진수 on 7/9/24.
//

import Foundation

// Implement
final class LikeRepositoryIMPL {
    
    private let mapper = DetailMapper()
    private let realmRepo = RealmRepository()
    
    func createLikeItem(likeItem: ShopItemEntity) -> Void? {
        
        let requestDTO = mapper.entityToDTO(likeItem)
        let result = realmRepo.create(data: requestDTO)
        
        switch result {
        case .success(let success):
            return ()
        case .failure(let error):
            print(error)
            return nil
        }
    }
    
    func fetchLikeItems() -> [ShopItemEntity] {
        let result = realmRepo.fetch()
        var resultEntity: [ShopItemEntity] = []
        
        for item in result {
            resultEntity.append(mapper.dtoToEntity(item))
        }
        
        return resultEntity
    }
    
    func deleteLikeItem(deleteItem: ShopItemEntity) -> Void {
        realmRepo.delete(data: deleteItem)
        
        return ()
    }
    
}
