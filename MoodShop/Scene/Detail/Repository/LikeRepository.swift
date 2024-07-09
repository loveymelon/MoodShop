//
//  DetailRepository.swift
//  MoodShop
//
//  Created by 김진수 on 7/9/24.
//

import Foundation

final class DetailRepository {
    
    let mapper = DetailMapper()
    let realmRepo = RealmRepository()
    
    func createLikeItem(likeItem: ShopItemEntity) {
        let requestDTO = mapper.entityToDTO(likeItem)
        let result = realmRepo.create(data: requestDTO)
        
        switch result {
        case .success(let success):
            print("")
        case .failure(let error):
            print(error)
        }
    }
    
    func 
    
}
