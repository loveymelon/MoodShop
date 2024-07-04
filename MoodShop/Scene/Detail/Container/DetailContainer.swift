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
        case onAppear
    }
    
    struct State {
        var error: String = ""
        var shopItems: [ShopItemEntity] = []
    }
    
    
    @Published
    private(set) var state: State = State()
    private let homeRepository = HomeRepository()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            Task {
                await searchNetwork(text: "코디")
                let a = CategoryEnum.allCases.map { $0.rawValue }
                for item in CategoryEnum.allCases {
                    await searchNetwork(text: item.rawValue, categoryEnum: item)
                }
            }
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
