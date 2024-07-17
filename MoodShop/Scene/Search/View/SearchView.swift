//
//  SearchView.swift
//  MoodShop
//
//  Created by 김진수 on 7/12/24.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject
    var container = SearchContainer()
//    @Environment(\.searchingText) private var recentText
    
    var body: some View {
        checkRecentData()
            .onAppear {
                container.send(.onAppear)
            }
            .onDisappear {
                container.send(.disAppear)
            }
            
    }
}

extension SearchView {
    @ViewBuilder
    private func checkRecentData() -> some View {
        if container.state.searchDatas.isEmpty {
            Text("최근 검색기록이 없습니다.")
        } else {
            createHeaderViews()
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 20) {
                    ForEach(Array(container.state.searchDatas.enumerated()), id: \.element.id) { index, item in
                        recentSearchViews(text: item.title, index: index)
                    }
                }
            }
        }
    }
    
    private func createHeaderViews() -> some View {
        return HStack {
            Text("최근 검색")
                .setTextStyle(size: 16, design: .default, weight: .bold)
            Spacer()
            Button {
                container.send(.deleteAll)
            } label: {
                Text("모두 지우기")
                    .setTextStyle(size: 16, design: .default, weight: .bold)
                    .foregroundStyle(Color.gray)
            }
        }
        .padding(.horizontal, 10)
    }
    
    private func recentSearchViews(text: String, index: Int) -> some View {
        
        let recentSearchView: some View = HStack {
            Image(systemName: "magnifyingglass")
            Text(text)
            Spacer()
            Button {
                container.send(.deleteSearch(index))
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.gray)
            }
        }.padding(.horizontal, 10)
        
        return recentSearchView
    }
}

// 값이 여러개 일때
//struct SearchText {
//    var recentText: String
//}
//
//extension SearchText: EnvironmentKey {
//    static let defaultValue: Self = Self(recentText: "")
//}
//
//extension EnvironmentValues {
//    var searchingText: SearchText {
//        get { self [SearchText.self] }
//        set { self [SearchText.self] = newValue }
//    }
//}

// 값 하나만 필요할때
//struct SearchText: EnvironmentKey {
//    static var defaultValue: String = ""
//}
//
//extension EnvironmentValues {
//    var searchingText: String {
//        get { self [SearchText.self] }
//        set { self [SearchText.self] = newValue }
//    }
//}
