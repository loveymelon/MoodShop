//
//  RouterProtocol.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import Foundation

enum BaseURL: String {
    case baseURL = "https://openapi.naver.com/"
}

enum Version: String {
    case version = "v1/"
}

enum Path: String {
    case path = "search/shop.json"
}

enum Header: String {
    case get = "GET"
}

enum QueryString: String {
    case query
    case display
    case start
    case sort
}

enum OptionalError: Error {
    case noData
}

protocol RouterProtocol {
    var header: Header { get }
    var baseURL: BaseURL { get }
    var version: Version { get }
    var path: Path { get }
    var queryString: [QueryString] { get }
}

extension RouterProtocol {
    func asURLRequest() throws -> URLRequest {
        
        guard let url = URL(string: baseURL.rawValue) else { throw OptionalError.noData }
        
        if #available(iOS 16.0, *) {
            let urlRequest = URLRequest(url: url.appending(path: version.rawValue + path.rawValue))
            
            return urlRequest
        } else {
            let urlRequest = URLRequest(url: url.appendingPathComponent(version.rawValue + path.rawValue))
            
            return urlRequest
        }
        
        
    }
}
