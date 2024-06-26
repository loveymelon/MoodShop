//
//  HeaderView.swift
//  MoodShop
//
//  Created by 김진수 on 6/24/24.
//

import SwiftUI
import Kingfisher

struct HeaderView: View {
    
    var shopItems: [ShopItemEntity]
    
    @State
    var selectedItem: ShopItemEntity?
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    @State
    var currentPage: Int = 0
    
    var body: some View {
        NavigationLink {
            DetailView(product: selectedItem)
        } label: {
            TabView(selection: $currentPage) {
                
                ForEach(0..<shopItems.count, id: \.self) { index in
                    
                    KFImage(shopItems[index].image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.all, 10)
                        .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
                            return [shopItems[index].productId: anchor]
                        })
                        .onTapGesture {
                            selectedItem = shopItems[index]
                        }
                    
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
            .onReceive(timer, perform: { _ in
                withAnimation {
                    currentPage = (currentPage + 1) % shopItems.count
                }
            })
        }
    }
}
