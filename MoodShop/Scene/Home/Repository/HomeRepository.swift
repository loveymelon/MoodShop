//
//  HomeRepository.swift
//  MoodShop
//
//  Created by 김진수 on 6/12/24.
//

import Foundation
import Combine

// 도메인을 담당하는 repository마다 프로토콜을 추가하는 이유
// 역할을 명시해줌으로써 명확한 책임분리를 가능하게 한다.
// 코드의 가독성 및 관리성이 용이해진다.
final class HomeRepository {
    
     // 각 repository마다 mapper가 무조건 다 필요하지않을까 그래서 프로토콜로 명시해주는건 어떨까?
    let mapper = HomeMapper()
    
    func fetchSearch(text: String, categoryType: CategoryEnum, display: String = "10") async -> AnyPublisher<ShopEntity, AppError> {
        
        return await NetworkManager.shared.search(text: text, display: display)
            .map { [weak self] result in
                guard let self else { return ShopEntity() }
                return mapper.dtoToEntity(data: result, categoryType: categoryType) }
            .eraseToAnyPublisher()
            
    }
}
