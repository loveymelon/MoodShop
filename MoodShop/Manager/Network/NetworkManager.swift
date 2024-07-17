//
//  NetworkManager.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import Foundation
import Combine

// session 열기
struct NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func search(text: String, start: String, display: String) async -> AnyPublisher<ShopModel, AppError> {
        
        return Future<ShopModel,AppError> { promise in
            
            Task {
                
                do {
                    
                    let request = try Router.search.asURLRequest(text: text, start: start, display: display)
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    try checkResponse(data: data, response: response)
                    
                    try promise(.success(decodeModel(data: data, type: ShopModel.self)))
                    
                } catch {
                    print(error)
                    promise(.failure(.networkError(.unowned)))
                }
                
            }
            
        }
        .eraseToAnyPublisher()
        
    }
    
}

extension NetworkManager {
    private func checkNetError(response: URLResponse?) throws {
        guard let urlResponse = response as? HTTPURLResponse else {
            throw AppError.commonError(.missingError)
        }
        
        print(urlResponse.statusCode)
        
    }
    
    private func checkResponse(data: Data, response: URLResponse) throws {
        
        guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
            
            guard response is HTTPURLResponse else {
                throw CommonError.missingError
            }
            
            let naverError = try decodeModel(data: data, type: ResponseErrorModel.self)
            
            throw NetworkError.failedRequest(NaverError(rawValue: naverError.errorCode)!)
            
        }
        
    }
    
    private func decodeModel<T: Decodable>(data: Data, type: T.Type) throws -> T {
        let result = JSONManager.shared.decoder(type: type, data: data)
        
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
        
    }
    
}
