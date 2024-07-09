//
//  LikeView.swift
//  MoodShop
//
//  Created by 김진수 on 7/9/24.
//

import SwiftUI
import Kingfisher

struct LikeView: View {
    
    @StateObject
    var container = LikeContainer()
    
    @State
    var selectedItem: ShopItemEntity?
    @State
    private var isDetailViewActive: Bool = false
    
    var body: some View {
        
            if !container.state.likeItems.isEmpty {
                
                ScrollView(.vertical) {
                    ForEach(container.state.likeItems, id: \.productId) { item in
                        KFImage(item.image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.all, 10)
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
                            .onTapGesture {
                                selectedItem = item
                                isDetailViewActive.toggle()
                            }
                    }
                }
                
            } else {
                Text("Bool")
            }
        
        NavigationLink(
            destination: DetailView(product: selectedItem),
            isActive: $isDetailViewActive,
            label: {
                EmptyView()
            }
        )
        
    }
}

#Preview {
    LikeView()
}
