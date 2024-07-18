//
//  DetailView.swift
//  MoodShop
//
//  Created by 김진수 on 6/25/24.
//

import SwiftUI
import Kingfisher
import WebKit

struct DetailView: View {
    
    var product: ShopItemEntity?
    
    @StateObject
    var container = DetailContainer()
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                makeImageView()
                makeTexts()
                Color.clear
                    .frame(height: 80)
                
            }
            .navigationTitle("Mood Shop")
            .navigationBarTitleDisplayMode(.inline)
            
            makeBottomButton()
            
        }.onAppear {
            if let product = product {
                container.send(.onAppear(product))
            }
        }
    }
}

extension DetailView {
    func makeImageView() -> some View {
        VStack(spacing: 0) {
            
            KFImage(product?.image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
//                        .frame(height: UIScreen.main.bounds.height / 2.5)
                .clipped()
            // 이미지 바텀을 스크롤 탑으로
        }
    }
    
    func makeTexts() -> some View {
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
            
            CategoryView(categoryItems: container.state.shopItems, productName: "다른 제품", categoryTitles: container.state.categoryTitles)
            
        }
        .background(Color.white)
        
        
    }
    
    func makeBottomButton() -> some View {
        HStack {
            HStack {
                Button {
                    container.send(.buyButtonTap)
                } label: {
                    Text("구매하기")
                        .sheet(isPresented: Binding {
                            container.state.buyButtonState
                        } set: { _ in }) {
                            if let link = product?.link {
                                WKWebHosting(url: link)
                                    .onDisappear {
                                        container.send(.disappear)
                                    }
                            }
                        }
                        .setTextStyle(size: 20, design: .monospaced, weight: .bold)
                        .foregroundStyle(Color.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                    LinearGradient(colors: [
                        Color.red.opacity(0.1), Color.blue.opacity(0.2)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 40))
                
                Button {
                    
                    withAnimation {
                        if let product = product {
                            container.send(.likeButtonTap(product))
                        }
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
            .padding(.horizontal, 20)
          
        }
        .background(Color.white)
       
    }
}

extension DetailView {
    func createTextView(text: String, size: CGFloat, design: Font.Design?, weight: Font.Weight?) -> some View {
        return Text(text.rmHTMLTag)
            .setTextStyle(size: size, design: design, weight: weight)
    }
}
