//
//  JsonManager.swift
//  MoodShop
//
//  Created by 김진수 on 6/13/24.
//

import Foundation

class JSONManager {
    static let shared = JSONManager()
    
    private init() { }
    
    private let jsonDecoder = JSONDecoder()

}

extension JSONManager {
    func decoder<T: Decodable>(type: T.Type, data: Data) -> Result<T, NetworkError> {
        do {
            let datas = try jsonDecoder.decode(type.self, from: data)
            
            return .success(datas)
            
        } catch {
            
            return .failure(.unowned)
        }
    }
}
