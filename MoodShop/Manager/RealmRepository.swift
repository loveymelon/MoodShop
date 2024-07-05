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
    
    func create(data: ShopItemEntity) throws {
        
        let imageURL = data.image?.absoluteString ?? ""
        
        do {
            
            try realm.write {
                let shopItem = ShopItemRequestDTO(title: data.title, link: data.link, image: imageURL, lprice: data.lprice, mallName: data.mallName, productId: data.productId)
                
                realm.add(shopItem, update: .modified)
            }
            
        } catch {
            
            throw RealmError.createFail
            
        }
        
    }
    
    func fetch() -> [ShopItemRequestDTO] {
        return Array(realm.objects(ShopItemRequestDTO.self))
    }
    
    func delete(data: ShopItemEntity) {
        let imageURL = data.image?.absoluteString ?? ""
        
        let shopItem = ShopItemRequestDTO(title: data.title, link: data.link, image: imageURL, lprice: data.lprice, mallName: data.mallName, productId: data.productId)
        
        realm.delete(shopItem)
    }
    
}
