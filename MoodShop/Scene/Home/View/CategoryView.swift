//
//  CategoryView.swift
//  MoodShop
//
//  Created by 김진수 on 6/24/24.
//

import SwiftUI
import Kingfisher

struct CategoryView: View {
    
    // 이것도 부모에서 받은 값으로 처리만 하기 때문에 Binding으로 처리하지 않은것이다.
    var categoryItems: [ShopItemEntity]
    var productName: String
    // Binding으로 하지 않고 클로저로 해결한 이유 :
    // 이건 부모에서 자식한테 값을 주고 자식이 그 값을 변경하는 양방향이 아니라
    // 자식이 부모한테 값을 주는 단방향이기 때문에 클로저로 해결하였다.
//    @Binding
//    var selectedItem: ShopItemEntity?
    @State
    var selectedItem: ShopItemEntity?
    @State
    private var isDetailViewActive: Bool = false
    
    var body: some View {
        
        HStack {
            Text(productName)
                .setTextStyle(size: 20, design: .monospaced, weight: .heavy)
                .padding(.leading, 10)
            
            Spacer()
        }
        
        ScrollView(.horizontal) {
            LazyHStack {
                
                ForEach(Array(categoryItems.enumerated()), id: \.element.productId) { index, item in

                    VStack {
                        
                        KFImage(item.image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.all, 10)
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
                            .onTapGesture {
                                selectedItem = item
                                isDetailViewActive.toggle()
                            }
                        
                        Text("\(item.lprice)")
                        
                    }
                    
                }
                
            }
            
        }
        .frame(maxWidth: .infinity)
        
        NavigationLink(
            destination: DetailView(product: selectedItem),
            isActive: $isDetailViewActive,
            label: {
                EmptyView()
            }
        )
        
    }
}
