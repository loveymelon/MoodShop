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
    }
    
    struct State {
        var likeItems: [ShopItemEntity] = []
    }
    
    @Published
    private(set) var state: State = State()
    private let repository = LikeRepositoryIMPL()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            state.likeItems = repository.fetchLikeItems()
        }
    }
    
}
