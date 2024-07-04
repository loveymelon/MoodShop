//
//  String+Extension.swift
//  MoodShop
//
//  Created by 김진수 on 6/20/24.
//

import Foundation

extension String {
    
    typealias ReadingOption = NSAttributedString.DocumentReadingOptionKey
    typealias DocumentType = NSAttributedString.DocumentType
    
    var rmHTMLTag: String {
            guard let data = self.data(using: .utf8) else { return self}
            let options: [ReadingOption : Any] = [
                .documentType: DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            do {
                let attrubuted = try NSAttributedString(
                    data: data,
                    options: options,
                    documentAttributes: nil)
                
                return attrubuted.string
            } catch {
                return self
            }
        }
}
