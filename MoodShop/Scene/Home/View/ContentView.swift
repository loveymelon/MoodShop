//
//  ContentView.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @State
    var searchText: String = ""
    @State
    var isEnter = false
    let repository = RealmRepository()
    
    var body: some View {
        NavigationView {
            HomeView()
                .searchable(text: $searchText)
                .background(
                    // 하위뷰로 보내기
                    NavigationLink(
                        destination: ShopItemListView(text: searchText),
                        isActive: $isEnter,
                        label: { EmptyView() }
                    )
                )
        }
        .tint(.black)
        .onSubmit(of: .search) {
            let result = repository.create(data: SearchRequestModel(title: searchText))
            
            switch result {
            case .success(_):
                isEnter = true
            case .failure(let failure):
                print(failure.description)
            }
        }
    }
}

