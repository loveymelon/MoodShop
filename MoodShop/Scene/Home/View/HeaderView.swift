//
//  HeaderView.swift
//  MoodShop
//
//  Created by 김진수 on 6/24/24.
//

import SwiftUI
import Kingfisher

struct HeaderView: View {
    
    @Binding
    var shopItems: [ShopItemEntity]
    
    var body: some View {
        TabView {
            ForEach(0..<shopItems.count, id: \.self) { index in
                
                KFImage(shopItems[index].image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.all, 10)
            }.onChange(of: shopItems) { newValue in
                print("newnewnew", newValue)
            }
        }
        .background(
            LinearGradient(colors: [
                Color.red.opacity(0.1), Color.blue.opacity(0.2)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .tabViewStyle(.page)
    }
}
