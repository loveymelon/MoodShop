//
//  RealmProtocol.swift
//  MoodShop
//
//  Created by 김진수 on 7/5/24.
//

import Foundation

protocol RealmProtocol {
    func create(data: ShopItemRequestDTO) -> Result<Void, RealmError>
    func fetch() -> [ShopItemRequestDTO]
    func delete(data: ShopItemEntity) -> Result<Void, RealmError>
}
