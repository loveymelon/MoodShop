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
    
    var header: Header {
        switch self {
        case .search:
            return .get
        }
    }
    
    var baseURL: BaseURL {
        switch self {
        case .search:
            return .baseURL
        }
    }
    
    var versopm: Version {
        switch self {
        case .search:
            return .version
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
            return [.display]
        }
    }
    
}
