//
//  HomeView.swift
//  MoodShop
//
//  Created by 김진수 on 7/16/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject
    var container = HomeContainer()
    @State
    var selectedProduct: ShopItemEntity?
    
    @Environment(\.isSearching) var searching
    
    var body: some View {
        searchingCheck(searching)
    }
}

extension HomeView {
    func makeCategoryView() -> some View {
        ForEach(CategoryEnum.allCases, id: \.self) { cases in
            
            if let items = container.state.categoryItems[cases], let titles = container.state.categoryTitles[cases] {
                
                CategoryView(categoryItems: items, productName: cases.rawValue, categoryTitles: titles)
                
            }
            
        }
    }
    
    func makeHomeView() -> some View {
        return ScrollView(.vertical) {
            
            HeaderView(shopItems: container.state.shopItems)
            makeCategoryView()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Mood Shop")
                    .setTextStyle(size: 30, design: .serif, weight: .semibold)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                
                NavigationLink {
                    LikeView()
                } label: {
                    Image("heart", bundle: nil)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

extension HomeView {
    func searchingCheck(_ searchValied: Bool) -> some View {
        return Group {
            if searchValied {
                SearchView()
            } else {
                makeHomeView()
                    .onAppear {
                        container.send(.onAppear)
                    }
            }
        }
    }
}
