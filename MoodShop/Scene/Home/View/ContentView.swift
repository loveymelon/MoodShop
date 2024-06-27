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
    
    @State
    var selectedProduct: ShopItemEntity?
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {
                
                HeaderView(shopItems: container.state.shopItems)
//                    .overlayPreferenceValue(MAnchorKey.self, { value in
//                        GeometryReader(content: { geometry in
//                            if let selectedProduct, let anchor = value[selectedProduct.productId] {
//                                let rect = geometry[anchor]
//                                
//                                ImageView(imageURL: selectedProduct.image, size: rect.size)
//                                    .offset(x: rect.minX, y: rect.minY)
//                                    .onAppear{
//                                        print("createdddd")
//                                    }
//            //                        .animation(.snappy(duration: 0.35, extraBounce: 0), value: rect)
//                            }
//                        })
//                        
//                    }) // 받는쪽
                
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
