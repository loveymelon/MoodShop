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
        
        Group {
            if !container.state.likeItems.isEmpty {
                contentView()
            } else {
                VStack(spacing: 10) {
                    Text("좋아하는 품목이 없어요")
                        .setTextStyle(size: 25, design: .default, weight: .heavy)
                    Image("People", bundle: nil)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            container.send(.onAppear)
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

extension LikeView {
    private func contentView() -> some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(container.state.likeItems, id: \.productId) { item in
                    HStack {
                        makeImage(item)
                        Spacer()
                        makeText(item)
                    }
                    Divider()
                        .frame(height: 1)
                        .overlay(Color.gray)
                        .opacity(0.2)
                }
            }
        }
    }
}

extension LikeView {
    
    private func makeImage(_ model: ShopItemEntity) -> some View {
        KFImage(model.image)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.all, 10)
            .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
            .shadow(color: .gray, radius: 4, x: 0, y: 0)
            .onTapGesture {
                selectedItem = model
                isDetailViewActive.toggle()
            }
    }
    
    private func makeText(_ model: ShopItemEntity) -> some View {
        VStack(alignment: .leading) {
            Group {
                Text(model.title)
                    .multilineTextAlignment(.center)
                HStack {
                    Spacer()
                    Text(model.mallName)
                }
                .padding(.trailing, 150)
                
                HStack {
                    
                    Text(model.lprice.description)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
           
        }
    }
}
