//
//  HomeRepository.swift
//  MoodShop
//
//  Created by 김진수 on 6/12/24.
//

import Foundation

// 도메인을 담당하는 repository마다 프로토콜을 추가하는 이유
// 역할을 명시해줌으로써 명확한 책임분리를 가능하게 한다.
// 코드의 가독성 및 관리성이 용이해진다.
final class HomeRepository: HomeRepositoryProtocol {

    let mapper = HomeMapper() // 각 repository마다 mapper가 무조건 다 필요하지않을까 그래서 프로토콜로 명시해주는건 어떨까?
    
    func fetchSearch(text: String, completionHandler: @escaping ((Result<ShopEntity, Error>) -> Void)) async throws  {
        
        await NetworkManager.shared.search(text: text) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                
                print("repository")
                
                completionHandler(.success(mapper.shopDtoToEntity(data: data)))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
        
    }
}
