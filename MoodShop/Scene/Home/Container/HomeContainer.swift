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
        case search(String)
        case searchTap
    }
    
    struct State {
        var text: String = ""
        var shopData = ShopEntity()
        var error: String = ""
    }
    
    let homeRepository = HomeRepository()
    
    @Published
    private(set) var state: State = State()
    
    func send(_ intent: Intent) {
        switch intent {
        case .search(let text):
            state.text = text

        case .searchTap:
            
            Task {
                do {
                    
                    try await homeRepository.fetchSearch(text: state.text) { [weak self] result in
                        
                        guard let self else {
                            self?.state.error = CommonError.missingError.description
                            return
                        }
                        
                        switch result {
                        case .success(let data):
                            print("container", data)
                            
                            DispatchQueue.main.async { [weak self] in
                                
                                guard let self else {
                                    self?.state.error = CommonError.missingError.description
                                    return
                                }
                                
                                state.shopData = data
                            }
                            
                        case .failure(let error):
                            state.error = error.description
                        }
                    }
                    
                } catch {
                    
                    state.error = CommonError.missingError.description
                    
                }
            }
            
        }
    }
    
}
