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
        var categoryItems: [CategoryEnum: [ShopItemEntity]] = [:]
        var categoryTitles: [CategoryEnum: [String]] = [:]
    }
    
    @Published
    private(set) var state: State = State()
    private var cancellables = Set<AnyCancellable>()
    
    private var homeRepository = HomeRepository()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            
            Task {
                await searchNetwork(text: "옷", display: "3")
                
                for item in CategoryEnum.allCases {
                    await searchNetwork(text: item.rawValue, categoryEnum: item)
                }
            
            }
            
        case .search(let text):
            state.text = text
            
        case .searchTap:
            
            Task {
                await searchNetwork(text: state.text)
            }
            
        case .change:
            state.imageIndex = ( state.imageIndex + 1 ) % 3
        }
        
    }
}

extension HomeContainer {
    private func searchNetwork(text: String, categoryEnum: CategoryEnum = .outerwear, display: String = "10") async {
        
        await homeRepository.fetchSearch(text: text, display: display)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                guard let self else { return }
                
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    state.error = error.description
                }
            }, receiveValue: { [weak self] data in
                
                guard let self else { return }
                
                if text == "옷" {
                    state.shopItems = data.items
                } else {
                    var temp: [String] = []
                    for item in data.items {
                        temp.append(item.title.rmHTMLTag)
                    }
                    
                    state.categoryTitles[categoryEnum] = temp
                    state.categoryItems[categoryEnum] = data.items
                }
                
            }).store(in: &cancellables)

    }
}
