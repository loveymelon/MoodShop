//
//  MAnchorKey.swift
//  MoodShop
//
//  Created by 김진수 on 6/25/24.
//

import SwiftUI

struct MAnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
