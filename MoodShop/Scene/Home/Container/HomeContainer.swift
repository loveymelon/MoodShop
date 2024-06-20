//
//  HomeContainer.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI
import Combine

// 역할 Intent, State에 따라 적절한 이벤트를 발생시켜야된다.
final class HomeContainer: ObservableObject, ContainerProtocol {
    
    enum Intent {
        case onAppear
        case search(String)
        case searchTap
        case change
    }
    
    struct State {
        var text: String = ""
        var shopItems: [ShopItemEntity] = []
        var shopData = ShopEntity()
        var error: String = ""
        var imageIndex: Int = 0
    }
    
    let homeRepository = HomeRepository()
    
    @Published
    private(set) var state: State = State()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            
            Task {
                
                await homeRepository.fetchSearch(text: "옷", display: "3")
                
                homeRepository.searchResult
                    .sink { [weak self] result in
                        
                        guard let self else {
                            
                            self?.state.error = CommonError.missingError.description
                            return
                            
                        }
                        
                        switch result {
                        case .success(let data):
                            print(data)
                            state.shopItems = data.items
                        case .failure(let error):
                            state.error = error.description
                        }
                    }
                    .store(in: &cancellables)
            }
            
        case .search(let text):
            state.text = text
            
        case .searchTap:
            
            Task {
                
                await homeRepository.fetchSearch(text: state.text)
                
                homeRepository.searchResult
                    .sink { [weak self] result in
                        
                        guard let self else {
                            
                            self?.state.error = CommonError.missingError.description
                            return
                            
                        }
                        
                        switch result {
                        case .success(let data):
                            state.shopItems = data.items
                        case .failure(let error):
                            state.error = error.description
                        }
                        
                    }
                    .store(in: &cancellables)
                
            }
            
        case .change:
            state.imageIndex = ( state.imageIndex + 1 ) % 3
            print(state.shopItems[state.imageIndex].image)
        }
        
    }
}


