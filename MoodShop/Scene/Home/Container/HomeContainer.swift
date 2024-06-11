//
//  HomeContainer.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI
import Combine

final class HomeContainer: ObservableObject, ContainerProtocol {
    
    enum Intent {
        case search(String)
        case searchTap
    }
    
    struct State {
        var text: String = ""
    }
    
    @Published
    private(set) var state: State = State()
    
    func send(_ intent: Intent) {
        switch intent {
        case .search(let text):
            state.text = text

            print(text)
        case .searchTap:
            
            Task {
                await NetworkManager.shared.search(text: state.text)
            }
            
            print("tap", state.text)
        }
    }
    
}
