//
//  ContentView.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject
    var container = HomeContainer()
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .onAppear {
                container.send(.onAppear)
                print(container.state.error, " aaa")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mood Shop")
                        .setTextStyle()
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
