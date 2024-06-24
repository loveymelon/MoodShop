//
//  ContentView.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @StateObject
    var container = HomeContainer()
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {
                
                HeaderView(shopItems: Binding(get: {
                    container.state.shopItems
                }, set: { _ in  }))
                
                ForEach(CategoryEnum.allCases, id: \.self) { item in
                    CategoryView(categoryItems: Binding(get: {
                        container.state.categoryItems
                    }, set: { _ in }), categoryType: item)
                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mood Shop")
                        .setTextStyle(size: 30, design: .serif, weight: .semibold)
                }
            }
            
        }
        .onAppear {
            container.send(.onAppear)
        }
        .searchable(text: Binding(get: {
            container.state.text
        }, set: { text, _ in
            container.send(.search(text))
        }))
        .onSubmit(of: .search) {
            container.send(.searchTap)
        }
    }
}
