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
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {
                
                HeaderView(shopItems: container.state.shopItems)
                
                ForEach(CategoryEnum.allCases, id: \.self) { cases in
                    
                    if let items = container.state.categoryItems[cases] {
                        
                        CategoryView(categoryItems: items, productName: cases.rawValue)
                        
                    }
                    
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

struct ImageView: View {
    var imageURL: URL?
    var size: CGSize
    
    var body: some View {
        KFImage(imageURL)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.all, 10)
//            .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
            .frame(width: size.width, height: size.height)
    }
}
