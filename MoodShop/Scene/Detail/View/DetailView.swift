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
    
    @StateObject
    var container = DetailContainer()
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    
                    KFImage(product?.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height / 2.5)
                    // 이미지 바텀을 스크롤 탑으로
                }
                
                VStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.gray.opacity(0.9)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    
                    createTextView(text: product!.title,
                                   size: 30,
                                   design: .monospaced,
                                   weight: .bold)
                    .padding(.horizontal, 10)
                    
                    Spacer(minLength: 20)
                    
                    HStack {
                        
                        createTextView(text: String().addComma(to: String(product!.lprice)),
                                       size: 20,
                                       design: .default,
                                       weight: .bold)
                        .padding(.leading, 20)
                        .foregroundStyle(Color.gray)
                        
                        Spacer()
                    
                        createTextView(
                            text: "구매 사이트 \(product!.mallName)",
                            size: 20,
                            design: .rounded,
                            weight: .semibold)
                        .padding(.trailing, 30)
                        .foregroundStyle(Color.gray)
                        
                    }
                    
                    Spacer(minLength: 20)
                    
                    HStack {
                        createTextView(text: "다른 제품", size: 20, design: .monospaced, weight: .bold)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    
                    CategoryView(categoryItems: container.state.shopItems, productName: "")
                    
                }
                .background(Color.white)
                
                Color.clear
                    .frame(height: 80)
                
            }
            .navigationTitle("Mood Shop")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                container.send(.onAppear)
            }
            
            HStack(spacing: 10) {
                
                Button {
                    print("tap")
                } label: {
                    Text("구매하기")
                        .setTextStyle(size: 20, design: .monospaced, weight: .bold)
                        .foregroundStyle(Color.black)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [
                        Color.red.opacity(0.1), Color.blue.opacity(0.2)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
                Button {
                    
                    withAnimation {
                        container.send(.likeButtonTap)
                    }
                    
                } label: {
                    Image(
                        container.state.likeButtonState ? "heartFill" : "heart",
                        label: Text("")
                    )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(width: 50)
                }
                .background(
                    LinearGradient(colors: [
                        Color.red.opacity(0.1), Color.blue.opacity(0.2)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
            }
            .frame(height: 50)
            .padding(.all, 20)
            
            
        }
    }
}

extension DetailView {
    func createTextView(text: String, size: CGFloat, design: Font.Design?, weight: Font.Weight?) -> some View {
        return Text(text.rmHTMLTag)
            .setTextStyle(size: size, design: design, weight: weight)
    }
}
