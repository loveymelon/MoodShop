//
//  DynamicTextModifier.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import SwiftUI

private struct DynamicTextModifier: ViewModifier {
    
    var size: CGFloat
    var design: Font.Design?
    var weight: Font.Weight?
    
    func body(content: Content) -> some View {
        if #available(iOS 16.1, *) {
            content
                .fontDesign(design)
                .fontWeight(weight)
                .font(.system(size: size))
        } else {
            content
                .font(.custom(customFontName(size: size, weight: weight, design: design), size: size))
        }
    }
    
    private func customFontName(size: CGFloat, weight: Font.Weight?, design: Font.Design?) -> String {
            var fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            
            if let weight = weight {
                switch weight {
                case .bold:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]])
                case .heavy:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.heavy]])
                case .light:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.light]])
                case .medium:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]])
                case .semibold:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]])
                case .thin:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.thin]])
                case .ultraLight:
                    fontDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.ultraLight]])
                default:
                    break
                }
            }
            
            if let design = design {
                switch design {
                case .serif:
                    fontDescriptor = fontDescriptor.withDesign(.serif) ?? fontDescriptor
                case .monospaced:
                    fontDescriptor = fontDescriptor.withDesign(.monospaced) ?? fontDescriptor
                case .rounded:
                    fontDescriptor = fontDescriptor.withDesign(.rounded) ?? fontDescriptor
                default:
                    break
                }
            }
            
            return UIFont(descriptor: fontDescriptor, size: size).fontName
        }

}

extension View {
    func setTextStyle(size: CGFloat, design: Font.Design?, weight: Font.Weight?) -> some View {
        modifier(DynamicTextModifier(size: size, design: design, weight: weight))
    }
}
