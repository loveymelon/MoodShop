//
//  CommonError.swift
//  MoodShop
//
//  Created by 김진수 on 6/12/24.
//

import Foundation

enum AppError: Error {
    case commonError(CommonError)
    case networkError(NetworkError)
    
    var description: String {
        switch self {
        case .commonError(let commonError):
            return commonError.description
        case .networkError(let networkError):
            return networkError.description
        }
    }
}

enum CommonError: Error {
    case missingError
    
    var description: String {
        switch self {
        case .missingError:
            return "알 수 없는 오류"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
    case unowned
    
    var description: String {
        switch self {
        case .invalidURL:
            return "invalidURL"
        case .invalidResponse:
            return "invalidResponse"
        case .noData:
            return "noData"
        case .failedRequest:
            return "failedRequest"
        case .invalidData:
            return "invalidData"
        case .unowned:
            return "알 수 없는 오류"
        }
    }
}


