//
//  DetailView.swift
//  MoodShop
//
//  Created by 김진수 on 6/25/24.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    var product: ShopItemEntity?
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            ImageView(imageURL: product?.image, size: size)
        })
        .frame(height: 400)
        .ignoresSafeArea() 
        
        Spacer()
    }
}
