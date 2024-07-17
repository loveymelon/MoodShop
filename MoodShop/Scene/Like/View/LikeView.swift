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
    
    let size = (UIScreen.main.bounds.width / 2) - 20
    
    var body: some View {
        
        contentView()
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Like")
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
                
                if !container.state.likeItems.isEmpty {
                    
                    ForEach(Array(container.state.likeItems.enumerated()), id: \.element.productId) { index, item in
                        HStack(spacing: 20) {
                            makeImage(item.image, size: 80)
                            makeText(item)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.all, 10)
                        .onTapGesture {
                            selectedItem = item
                            isDetailViewActive.toggle()
                        }
                        
                        makeSeperator(index: index)
                        
                    }
                    
                } else {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text("좋아하는 품목을 찾고 있어요")
                            .setTextStyle(size: 20, design: .default, weight: .heavy)
                            .foregroundStyle(Color.gray)
                        Image("People", bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 50)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Divider()
                   .frame(height: 10)
                   .overlay(Color.gray)
                   .opacity(0.2)
                
                HStack {
                    Text("최근 본 상품과 비슷한 상품")
                        .padding(.leading, 10)
                        .setTextStyle(size: 18, design: .default, weight: .bold)
                    Spacer()
                }
                .padding(.vertical, 10)
                
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    
                    makeLatestItems()
                    
                }
                .padding(.horizontal, 10)
                
            }
        }
    }
}

extension LikeView {
    
    private func makeImage(_ imageURL: URL?, size: CGFloat) -> some View {
        KFImage(imageURL)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: size, height: size)
            .shadow(color: .gray, radius: 4, x: 0, y: 0)
    }
    
    private func makeText(_ model: ShopItemEntity) -> some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .lineLimit(2)
            Text(model.mallName)
            Text(String().addComma(to: model.lprice.description))
        }
    }
    
    private func makeSeperator(index: Int) -> some View {
        Group {
            if index != container.state.likeItems.count - 1 {
                Divider()
                    .frame(height: 1)
                    .overlay(Color.gray)
                    .opacity(0.2)
            } else {
                EmptyView()
            }
        }
    }
    
    private func makeLatestItems() -> some View {
        ForEach(Array(container.state.shopItems.enumerated()), id: \.element.productId) { index, item in
            VStack(spacing: 5) {
                makeImage(item.image, size: size)

                VStack(alignment: .leading) {
                    Text(item.mallName)
                        .setTextStyle(size: 16, design: .default, weight: .bold)
                    Text(container.state.shopItemTitle[index])
                        .lineLimit(2)
                    Text(String().addComma(to: item.lprice.description))
                        .setTextStyle(size: 16, design: .default, weight: .bold)
                }
                .padding(.leading, 5)
            }
            .onTapGesture {
                selectedItem = item
                isDetailViewActive.toggle()
            }
            
        }
    }
}
