//
//  ShopModel.swift
//  MoodShop
//
//  Created by 김진수 on 6/11/24.
//

import Foundation

// DTO
struct ShopModel: Decodable {
    let total: Int
    let start: Int
    let display: Int
    let items: [ShopItem]
}

struct ShopItem: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}
