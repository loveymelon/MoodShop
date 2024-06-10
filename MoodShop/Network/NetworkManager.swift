//
//  NetworkManager.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import Foundation

class NetworkManager {
    let shared = NetworkManager()
    
    private init() { }
    
    let url = URL(string: "https://openapi.naver.com/v1/search/shop.json")
    
    let a = Router.search
    
    
}
