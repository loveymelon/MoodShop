//
//  CategoryView.swift
//  MoodShop
//
//  Created by 김진수 on 6/24/24.
//

import SwiftUI
import Kingfisher

struct CategoryView: View {
    
    var categoryItems: [ShopItemEntity]
    var productName: String
    
    var body: some View {
        
        HStack {
            Text(productName)
                .setTextStyle(size: 20, design: .monospaced, weight: .heavy)
                .padding(.leading, 10)
            
            Spacer()
        }
        
        ScrollView(.horizontal) {
            LazyHStack {
                
                ForEach(categoryItems, id: \.productId) { item in
                    VStack {
                        KFImage(item.image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.all, 10)
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
                        Text("\(item.lprice)")
                    }
                    .onTapGesture {
                        print("tap")
                    }
                }
            }

        }
        .frame(maxWidth: .infinity)
        
    }
}
