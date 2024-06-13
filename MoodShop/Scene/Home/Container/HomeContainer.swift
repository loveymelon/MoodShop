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
    }
    
    struct State {
        var text: String = ""
        var shopItems: [ShopItemEntity] = []
        var shopData = ShopEntity()
        var error: String = ""
    }
    
    let homeRepository = HomeRepository()
    
    @Published
    private(set) var state: State = State()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            
            Task {
                await homeRepository.fetchSearch(text: "옷") { [weak self] result in
                    
                    guard let self else {
                        
                        self?.state.error = CommonError.missingError.description
                        return
                    }
                    
                    switch result {
                    case .success(let data):
                        var tempDatas: [ShopItemEntity] = []
        
                        for item in data.items {
                            tempDatas.append(item)
                            print(item)
                            if tempDatas.count == 3 {
                                break
                            }
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self else {
                                self?.state.error = CommonError.missingError.description
                                return
                            }
                            
                            state.shopItems = tempDatas
                            
                        }
                        
                    case .failure(let error):
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self else {
                                self?.state.error = CommonError.missingError.description
                                return
                            }
                            
                            self.state.error = error.description
                        }
                    }
                    
                }
            }
            
        case .search(let text):
            state.text = text
            
        case .searchTap:
            
            Task {
                
                await homeRepository.fetchSearch(text: state.text) { [weak self] result in
                    
                    guard let self else {
                        self?.state.error = CommonError.missingError.description
                        return
                    }
                    
                    switch result {
                    case .success(let data):
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self else {
                                self?.state.error = CommonError.missingError.description
                                return
                            }
                            
                            state.shopData = data
                            print(data)
                        }
                        
                    case .failure(let error):
                        
                        DispatchQueue.main.async {
                            self.state.error = error.description
                        }
                
                    }
                }
                
            }
        }
        
    }
}


