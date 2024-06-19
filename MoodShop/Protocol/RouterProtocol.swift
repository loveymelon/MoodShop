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

enum Method: String {
    case get = "GET"
}

enum QueryString: String {
    case query
    case display
    case start
    case sort
}

protocol RouterProtocol {
    var header: [String: String] { get }
    var baseURL: BaseURL { get }
    var version: Version { get }
    var path: Path { get }
    var method: Method { get }
    var queryString: [QueryString] { get }
}

extension RouterProtocol {
    func asURLRequest(text: String, display: String = "10") throws -> URLRequest {
        
        guard let url = URL(string: baseURL.rawValue) else { throw NetworkError.invalidURL }
        var urlRequest: URLRequest
        
        if #available(iOS 16.0, *) {
            urlRequest = URLRequest(url: url.appending(path: version.rawValue + path.rawValue))
        } else {
            urlRequest = URLRequest(url: url.appendingPathComponent(version.rawValue + path.rawValue))
        } // 이정도면 따로 함수로 안빼고 놔둬도 괜찮겠지?
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        
        for item in queryString {
            
            var query = ""
            
            if item.rawValue == "query" {
                
                query = text
                
            } else {
                
                query = display
                
            }
                
            let queryItem = URLQueryItem(name: item.rawValue, value: query)
            
            if #available(iOS 16.0, *) {
                
                urlRequest.url?.append(queryItems: [queryItem])
                
            } else {
                
                guard let requestURL = urlRequest.url else { throw NetworkError.invalidResponse }
                
                urlRequest.url = appendQueryItems(to: requestURL, queryItems: [queryItem])
                
            }
        }
        
        return urlRequest
        
    }
    
    private func appendQueryItems(to url: URL, queryItems: [URLQueryItem]) -> URL? {
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var newQueryItems = urlComponents?.queryItems ?? []
        
        newQueryItems.append(contentsOf: queryItems)
        urlComponents?.queryItems = newQueryItems
        
        return urlComponents?.url
    }
}
