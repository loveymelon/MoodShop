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
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    @State
    var selectedItem: ShopItemEntity?
    @State
    private var currentPage: Int = 0
    
    @State
    var isZoom: Bool = false
    
    var body: some View {
        NavigationLink {
            DetailView(product: selectedItem)
        } label: {
            TabView(selection: $currentPage) {
                
                ForEach(shopItems, id: \.productId) { item in
                    
                    KFImage(item.image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.all, 10)
                        .onTapGesture {
                            selectedItem = item
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
