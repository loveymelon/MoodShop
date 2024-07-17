//
//  ShopItemListContainer.swift
//  MoodShop
//
//  Created by 김진수 on 7/17/24.
//

import SwiftUI
import Combine

final class ShopItemListContainer: ObservableObject, ContainerProtocol {
    
    enum Intent {
        case onAppear(String)
        case nextPage(Int)
        case network
    }
    
    struct State {
        var shopItems: [ShopItemEntity] = []
        var error: String = ""
        var shopItemTitles: [String] = []
    }
    
    @Published
    var state: State = State()
    private var cancellables = Set<AnyCancellable>()
    private var repository = HomeRepository()
    private var title = ""
    private var start = 1
    private var total = 0
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear(let text):
            title = text
            send(.network)
        case .nextPage(let index):
            if index + 2 >= state.shopItems.count  && index != total - 1 {
                print("next")
                start += 10
                send(.network)
            }
        case .network:
            Task {
                await searchNetwork(text: title, start: String(start))
            }
        }
    }
}

extension ShopItemListContainer {
    private func searchNetwork(text: String, start: String, display: String = "10") async {
        
        await repository.fetchSearch(text: text, start: start, display: display)
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
                
                print(data.start)
                
                total = data.total
                
                state.shopItemTitles.append(contentsOf: temp)
                state.shopItems.append(contentsOf: data.items)
                
            }).store(in: &cancellables)
        
    }
}
