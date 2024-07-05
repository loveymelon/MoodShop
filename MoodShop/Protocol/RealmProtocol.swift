//
//  RealmProtocol.swift
//  MoodShop
//
//  Created by 김진수 on 7/5/24.
//

import Foundation

protocol RealmProtocol {
    func create(data: ShopItemEntity) throws
    func fetch() -> [ShopItemRequestDTO]
    func delete(data: ShopItemEntity)
}
