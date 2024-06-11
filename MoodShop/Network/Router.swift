//
//  Router.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import Foundation

enum Router {

    case search
    
}

extension Router: RouterProtocol {
    var version: Version {
        switch self {
        case .search:
            return .version
        }
    }
    
    var method: Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    
    var header: [String: String] {
        switch self {
        case .search:
            return [
                "X-Naver-Client-Id": APIKey.clientId.rawValue,
                "X-Naver-Client-Secret": APIKey.clientSecret.rawValue,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var baseURL: BaseURL {
        switch self {
        case .search:
            return .baseURL
        }
    }
    
    var path: Path {
        switch self {
        case .search:
            return .path
        }
    }
    
    var queryString: [QueryString] {
        switch self {
        case .search:
            return [.query]
        }
    }
    
}
