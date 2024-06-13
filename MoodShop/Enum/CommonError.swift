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
    case failedRequest(NaverError)
    case decodingError
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
        case .decodingError:
            return "decodingError"
        case .unowned:
            return "알 수 없는 오류"
        }
    }
}

enum NaverError: String, Error {
    case incorrectQuery = "SE01"
    case invalidDisplay = "SE02"
    case invalidStar = "SE03"
    case invalidSort = "SE04"
    case invalidEncode = "SE06"
    case invalidSearch = "SE05"
    case systemError = "SE99"
    
//    case errorCode(String)
//    
//    var description: String {
//
//    }
    
//    var description: String {
//        switch self {
//        case .incorrectQuery:
//            return "incorrectQuery"
//        case .invalidDisplay:
//            return "invalidDisplay"
//        case .invalidStar:
//            return "invalidStar"
//        case .invalidSort:
//            return "invalidSort"
//        case .invalidEncode:
//            return "invalidEncode"
//        case .invalidSearch:
//            return "invalidSearch"
//        case .systemError:
//            return "systemError"
//        }
//    }
}
