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
        var categoryItems: [ShopItemEntity] = []
    }
    
    @Published
    private(set) var state: State = State()
    private var cancellables = Set<AnyCancellable>()
    
    lazy var homeRepository = HomeRepository(cancellables)
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
                
            searchNetwork(text: "옷", display: "3")
            searchNetwork(text: "아웃도어")
            
        case .search(let text):
            state.text = text
            
        case .searchTap:
            
            searchNetwork(text: state.text)
            
        case .change:
            state.imageIndex = ( state.imageIndex + 1 ) % 3
        }
        
    }
}

extension HomeContainer {
    private func searchNetwork(text: String, display: String = "10") {
        Task {
            await homeRepository.fetchSearch(text: text, display: display)
            
            homeRepository.searchResult
                .receive(on: RunLoop.main)
                .sink { [weak self] result in
                    
                    guard let self else {
                        
                        self?.state.error = CommonError.missingError.description
                        return
                        
                    }
                    
                    switch result {
                    case .success(let data):
                        if text == "옷" {
                            print(data.items)
                            state.shopItems = data.items
                        } else {
                            state.categoryItems = data.items
                        }
                    case .failure(let error):
                        state.error = error.description
                    }
                }
                .store(in: &cancellables)
        }
    }
}
