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
                TabView {
                    ForEach(0..<container.state.shopItems.count, id: \.self) { index in
                        
                        KFImage(container.state.shopItems[index].image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.all, 10)
                            .onAppear {
//                                print(container.state.shopItems.count)
//                                print(index)
                            }
                    }
                }
                .background(
                    LinearGradient(colors: [
                        Color.red.opacity(0.1), Color.blue.opacity(0.2)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .tabViewStyle(.page)
                
                HStack {
                    Text("Outerwear")
                        .setTextStyle(size: 20, design: .monospaced, weight: .heavy)
                        .padding(.leading, 10)
                        .background(.red)
                    
                    Spacer()
                }
                .padding(.bottom, 10)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        
                        ForEach(container.state.categoryItems, id: \.productId) { item in
                            KFImage(item.image)
                                .resizable()
                                .padding(.all, 10)
                                .frame(width: UIScreen.main.bounds.width)
                        }
                        
                    }

                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                                
            }
            .onAppear {
                container.send(.onAppear)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mood Shop")
                        .setTextStyle(size: 30, design: .serif, weight: .semibold)
                }
            }
            
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
