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
                
                Spacer(minLength: 30)
                
                HStack {
                    
                    createTextView(text: "₩ \(product!.lprice)",
                                   size: 20,
                                   design: .default,
                                   weight: .bold)
                    .padding(.leading, 30)
                    
                    Spacer()
                    
                    createTextView(
                        text: product!.mallName,
                        size: 20,
                        design: .rounded,
                        weight: .semibold)
                    .padding(.leading, 20)
                    
                }
                
                Spacer(minLength: 20)
                
                createTextView(text: "다른 제품", size: 20, design: .monospaced, weight: .bold)
                
                CategoryView(categoryItems: container.state.shopItems, productName: "")
                
            }
            .background(Color.white)
            
        }
        .onAppear {
            container.send(.onAppear)
        }
        
        
        //        VStack {
        //            ScrollView(.vertical) {
        //                ZStack(alignment: .bottom) {
        //                    KFImage(product?.image)
        //                        .resizable()
        //                        .clipShape(RoundedRectangle(cornerRadius: 10))
        //                        .frame(width: .infinity, height: UIScreen.main.bounds.height / 2.5)
        //                        .onAppear {
        //                            print(product)
        //                        }
        //
        //                    Text(product!.title)
        //                        .frame(width: 100)
        //
        ////                    LinearGradient(
        ////                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.2)]),
        ////                        startPoint: .center,
        ////                        endPoint: .bottom
        ////                    )
        ////                    .frame(height: 200)
        ////                    .clipShape(RoundedRectangle(cornerRadius: 10))
        //                }
        //                Rectangle()
        //                    .background(Color.gray)
        //                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
        //            }
        //        }
        
        //        if let product {
        //            GeometryReader(content: { geometry in
        //                let size = geometry.size
        //
        //                Color.clear
        //                    .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
        //                        return [product.productId: anchor]
        //                    })
        //
        ////                ImageView(imageURL: product .image, size: rect.size)
        ////                    .onAppear {
        ////                        print(rect.size)
        ////                    }
        //            })
        //            .onAppear {
        //                print("none", product.title)
        //            }
        //            .frame(height: 400)
        //
        //            Spacer()
        //        }
        
    }
}

extension DetailView {
    func createTextView(text: String, size: CGFloat, design: Font.Design?, weight: Font.Weight?) -> some View {
        return Text(text)
            .setTextStyle(size: size, design: design, weight: weight)
    }
}
