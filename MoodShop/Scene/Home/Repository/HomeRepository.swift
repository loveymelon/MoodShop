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
final class HomeRepository: HomeRepositoryProtocol {
    
    let searchResult = PassthroughSubject<Result<ShopEntity, AppError>, Never>() // publishSubject
//    var a = CurrentValueSubject<String>(value: "a")
    private let mapper = HomeMapper() // 각 repository마다 mapper가 무조건 다 필요하지않을까 그래서 프로토콜로 명시해주는건 어떨까?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSearch(text: String, display: String = "10") async {
        
        await NetworkManager.shared.search(text: text, display: display)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                
                guard let self else { return }
                
                switch completion {
                    
                case .finished:
                    print("finish")
                case .failure(let error):
                    searchResult.send(.failure(error))
                }
                
            } receiveValue: { [weak self] model in
                guard let self else { return }
                
                let entity = mapper.dtoToEntity(data: model)
                searchResult.send(.success(entity))
            }
            .store(in: &cancellables)
        
    }
}
