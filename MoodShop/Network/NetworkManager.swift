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
    
    func search(text: String, completionHandler: @escaping (Result<ShopModel, AppError>) -> Void) async {
        
        do {
            let request = try Router.search.asURLRequest(text: text)
            
            try await URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    
                    completionHandler(.failure(.networkError(.failedRequest(.incorrectQuery))))
                    
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                        
                    guard let urlResponse = response as? HTTPURLResponse else { 
                        completionHandler(.failure(.commonError(.missingError)))
                        return
                    }
                    
                    switch JSONManager.shared.decoder(type: ResponseErrorModel.self, data: data!) {
                    case .success(let data):
                        
                        let naverError = NaverError(rawValue: data.errorCode)
                        
                        completionHandler(.failure(.networkError(.failedRequest(naverError!))))
                    case .failure(let error):
                        completionHandler(.failure(.networkError(error)))
                    }
                    
//                    try checkNetError(response: response)
                    
                    completionHandler(.failure(.networkError(.invalidResponse)))
                    return
                }
                
                guard let output = try? JSONDecoder().decode(ShopModel.self, from: data) else {
                    completionHandler(.failure(.networkError(.decodingError)))
                    return
                }
                
                completionHandler(.success(output))
                
            }.resume()
            
        } catch {
            completionHandler(.failure(.networkError(.unowned)))
        }
        
    }
    
}

extension NetworkManager {
    private func checkNetError(response: URLResponse?) throws {
        guard let urlResponse = response as? HTTPURLResponse else {
            throw AppError.commonError(.missingError)
        }
        
        print(urlResponse.statusCode)
        
    }
}
