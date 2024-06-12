//
//  NetworkManager.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func search(text: String, completionHandler: @escaping (Result<ShopModel, NetworkError>) -> Void) async {
        
        do {
            let request = try Router.search.asURLRequest(text: text)
            
            try await URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    completionHandler(.failure(.unowned))
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                
                guard let output = try? JSONDecoder().decode(ShopModel.self, from: data) else {
                    completionHandler(.failure(.invalidData))
                    return
                }
                
                completionHandler(.success(output))
                
            }.resume()
            
        } catch {
            completionHandler(.failure(.unowned))
        }
        
    }
    
}
