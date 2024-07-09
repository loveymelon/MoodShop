//
//  DetailContainer.swift
//  MoodShop
//
//  Created by 김진수 on 7/4/24.
//

import SwiftUI
import Combine

final class DetailContainer: ObservableObject, ContainerProtocol {
    
    enum Intent {
        case onAppear(ShopItemEntity)
        case netTrigger
        case likeButtonTap(ShopItemEntity)
        case buyButtonTap
        case disappear
    }
    
    struct State {
        var error: String = ""
        var shopItems: [ShopItemEntity] = []
        var likeButtonState: Bool = false
        var netState: Bool = false
        var buyButtonState: Bool = false
    }
    
    @Published
    private(set) var state: State = State()
    private let homeRepository = HomeRepository()
    private let likeRepository = LikeRepositoryIMPL()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear(let item):
            let likeItems = likeRepository.fetchLikeItems()
            
            if !state.netState {
                send(.netTrigger)
                state.netState.toggle()
            }
            
            state.likeButtonState = likeItems.contains(item)
            
        case .netTrigger:
            Task {
                await searchNetwork(text: "시즌")
                
                for item in CategoryEnum.allCases {
                    await searchNetwork(text: item.rawValue, categoryEnum: item)
                }
            }
        case .likeButtonTap(let item):
            
            state.likeButtonState.toggle()
            
            if state.likeButtonState {
                likeRepository.createLikeItem(likeItem: item)
            } else {
                likeRepository.deleteLikeItem(deleteItem: item)
            }
        case .buyButtonTap:
            state.buyButtonState.toggle()
        case .disappear:
            state.buyButtonState.toggle()
        }
    }
}

extension DetailContainer {
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
                
                state.shopItems = data.items
                
            }).store(in: &cancellables)

    }
}
