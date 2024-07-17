//
//  SearchContainer.swift
//  MoodShop
//
//  Created by 김진수 on 7/12/24.
//

import SwiftUI
import Combine

final class SearchContainer: ObservableObject, ContainerProtocol {

    enum Intent {
        case onAppear
        case searchEnter(String)
        case deleteSearch(Int)
        case deleteAll
        case disAppear
    }
    
    struct State {
        var error: String = ""
        var searchDatas: [SearchRequestModel] = []
    }
    
    @Published
    private(set)var state: State = State()
    private let realmRepository = RealmRepository()
    
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ intent: Intent) {
        switch intent {
        case .onAppear:
            let searchDatas = realmRepository.fetch(type: SearchRequestModel.self)
            state.searchDatas = searchDatas
        case .searchEnter(let text):
            switch realmRepository.create(data: SearchRequestModel(title: text)) {
                
            case .success(_):
                print("success")
            case .failure(let error):
                state.error = error.description
            }
        case .deleteSearch(let index):
            let result = realmRepository.delete(data: state.searchDatas[index], type: SearchRequestModel.self, id: state.searchDatas[index].id)
            
            switch result {
            case .success(_):
                send(.onAppear)
            case .failure(let failure):
                state.error = failure.description
            }
        case .deleteAll:
            switch realmRepository.deleteAll() {
            case .success(_):
                state.searchDatas = []
            case .failure(let error):
                state.error = error.description
            }
        case .disAppear:
            cancellables.removeAll()
        }
    }
    
}
