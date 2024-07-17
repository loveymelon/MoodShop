//
//  ShopItemListView.swift
//  MoodShop
//
//  Created by 김진수 on 7/17/24.
//

import SwiftUI
import Kingfisher

struct ShopItemListView: View {
    
    var text: String
    private let size = (UIScreen.main.bounds.width / 2) - 20
    
    @State
    var selectedItem: ShopItemEntity?
    @State
    private var isDetailViewActive: Bool = false
    @StateObject
    private var container = ShopItemListContainer()
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(ButtonTypeEnum.allCases, id: \.self) { title in
                        makeButtons(title.rawValue)
                    }
                }
                .padding(.leading, 8)
            }
            .padding(.vertical, 8)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                makeItemList()
            }
        }
        .onAppear {
            container.send(.onAppear(text))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Mood Shop")
                    .setTextStyle(size: 30, design: .serif, weight: .semibold)
            }
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

extension ShopItemListView {
    private func makeButtons(_ buttonTitle: String) -> some View {
        Button {
            print("tap")
        } label: {
            Text(buttonTitle)
                .foregroundStyle(Color.black)
        }
        .padding(.all, 5)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.black, lineWidth: 1)
        }
        .tag(/*@START_MENU_TOKEN@*/"Tag"/*@END_MENU_TOKEN@*/)
        
    }
    
    private func makeImage(_ imageURL: URL?, size: CGFloat) -> some View {
        KFImage(imageURL)
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: size, height: size)
            .shadow(color: .gray, radius: 4, x: 0, y: 0)
    }
    
    private func makeItemList() -> some View {
        ForEach(Array(container.state.shopItems.enumerated()), id: \.element.self) { index, item in
            VStack(spacing: 5) {
                makeImage(item.image, size: size)

                VStack(alignment: .leading) {
                    Text(item.mallName)
                        .setTextStyle(size: 16, design: .default, weight: .bold)
                    Text(container.state.shopItemTitles[index])
                        .lineLimit(2)
                    Text(String().addComma(to: item.lprice.description))
                        .setTextStyle(size: 16, design: .default, weight: .bold)
                }
                .frame(width: size)
                .padding(.leading, 5)
                .onAppear {
                    container.send(.nextPage(index))
                }
            }
            .onTapGesture {
                selectedItem = item
                isDetailViewActive.toggle()
            }
            
        }
    }
}
