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
    var categoryTitles: [String]
    // Binding으로 하지 않고 클로저로 해결한 이유 :
    // 이건 부모에서 자식한테 값을 주고 자식이 그 값을 변경하는 양방향이 아니라
    // 자식이 부모한테 값을 주는 단방향이기 때문에 클로저로 해결하였다.
//    @Binding
//    var selectedItem: ShopItemEntity?
    private let size = UIScreen.main.bounds.width / 2.5
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
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                
                ForEach(Array(categoryItems.enumerated()), id: \.element.productId) { index, item in

                    VStack {
                        
                        KFImage(item.image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.all, 10)
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
                            .shadow(color: .gray, radius: 4, x: 0, y: 0)
                            .onTapGesture {
                                selectedItem = item
                                isDetailViewActive.toggle()
                            }
                        
                        VStack(alignment: .leading) {
                            Text(categoryTitles[index])
                                .lineLimit(1)
                                .setTextStyle(size: 15, design: .default, weight: .thin)
                            Text(String().addComma(to: String(item.lprice)))
                                .setTextStyle(size: 16, design: .default, weight: .bold)
                        }
                        .frame(width: size - 10)
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
