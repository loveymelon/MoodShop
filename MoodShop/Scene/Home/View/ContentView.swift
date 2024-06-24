//
//  ContentView.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    
    @StateObject
    var container = HomeContainer()
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {
                
                HeaderView(shopItems: Binding(get: {
                    container.state.shopItems
                }, set: { _ in  }))
                
                HStack {
                    Text("Outerwear")
                        .setTextStyle(size: 20, design: .monospaced, weight: .heavy)
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                .padding(.top, 30)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        
                        ForEach(container.state.categoryItems, id: \.productId) { item in
                            VStack {
                                KFImage(item.image)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.all, 10)
                                    .frame(width: UIScreen.main.bounds.width / 2.5, height: 200)
                                Text("\(item.lprice)")
                            }
                        }
                    }

                }
                .frame(maxWidth: .infinity)

                                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mood Shop")
                        .setTextStyle(size: 30, design: .serif, weight: .semibold)
                }
            }
            
        }
        .onAppear {
            container.send(.onAppear)
        }
        .searchable(text: Binding(get: {
            container.state.text
        }, set: { text, _ in
            container.send(.search(text))
        }))
        .onSubmit(of: .search) {
            container.send(.searchTap)
        }
    }
}
