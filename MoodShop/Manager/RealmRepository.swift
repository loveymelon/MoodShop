//
//  RealmRepository.swift
//  MoodShop
//
//  Created by 김진수 on 7/5/24.
//

import RealmSwift
import Foundation

final class RealmRepository: RealmProtocol {
    
    private let realm = try! Realm()
    
    func create(data: ShopItemRequestDTO) -> Result<Void, RealmError> {
        
        do {
            
            try realm.write {
                
                print("dd", realm.configuration.fileURL)
                realm.add(data, update: .modified)
                
            }
            
            return .success(())
            
        } catch {
            
            return .failure(.createFail)
            
        }
        
    }
    
    func fetch() -> [ShopItemRequestDTO] {
        return Array(realm.objects(ShopItemRequestDTO.self))
    }
    
    func delete(data: ShopItemEntity) -> Result<Void, RealmError> {
        let imageURL = data.image?.absoluteString ?? ""
        
//        let shopItem = ShopItemRequestDTO(title: data.title, link: data.link, image: imageURL, lprice: data.lprice, mallName: data.mallName, productId: data.productId)
        
        let shopItem = realm.objects(ShopItemRequestDTO.self).where {
            $0.productId == data.productId
        }
        
        do {
            
            try realm.write {
                realm.delete(shopItem)
            }
            return .success(())
            
        } catch {
            return .failure(.deleteFail)
        }
    }
    
}
