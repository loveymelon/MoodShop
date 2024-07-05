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
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

}

extension JSONManager {
    func decoder<D: Decodable>(type: D.Type, data: Data) -> Result<D, NetworkError> {
        
        
        do {
            let datas = try jsonDecoder.decode(type.self, from: data)
            
            return .success(datas)
            
        } catch {
            return .failure(.unowned)
        }
    }
    
    func encoder<E: Encodable>(data: E) -> Data? {
        
        do {
            return try jsonEncoder.encode(data)
        } catch {
            return nil
        }
    }
}
