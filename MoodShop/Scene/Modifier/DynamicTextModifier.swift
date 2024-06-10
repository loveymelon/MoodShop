//
//  DynamicTextModifier.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI

private struct DynamicTextModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 16.1, *) {
            content
                .fontDesign(.serif)
                .fontWeight(.semibold)
                .font(.system(size: 30))
        } else {
            content
                .font(.system(size: 30, weight: .semibold, design: .serif))
        }
    }

}

extension View {
    func setTextStyle() -> some View {
        modifier(DynamicTextModifier())
    }
}
