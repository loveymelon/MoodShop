//
//  LikeContainer.swift
//  MoodShop
//
//  Created by 김진수 on 7/9/24.
//

import SwiftUI
import Combine

final class LikeContainer: ObservableObject, ContainerProtocol {
    
    enum Intent {
        case onAppear
        case netTrigger
    }
    
    struct State {
        var likeItems: [ShopItemEntity] = []
        var netState: Bool = false
        var error: String = ""
        var shopItems: [ShopItemEntity] = []
        var shopItemTitle: [String] = []
    }
    
    @Published
    private(set) var state: State = State()
    private let repository = LikeRepositoryIMPL()
    private let homeRepository = HomeRepository()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            state.likeItems = repository.fetchLikeItems()
            
            if !state.netState {
                send(.netTrigger)
                state.netState.toggle()
            }
            
        case .netTrigger:
            Task {
                await searchNetwork(text: "아우터")
            }
        }
    }
    
}

extension LikeContainer {
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
                
                var temp: [String] = []
                for item in data.items {
                    temp.append(item.title.rmHTMLTag)
                }
                
                state.shopItemTitle = temp
                state.shopItems = data.items
                
            }).store(in: &cancellables)

    }
}
