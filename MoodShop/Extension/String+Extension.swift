//
//  String+Extension.swift
//  MoodShop
//
//  Created by 김진수 on 6/20/24.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            print("Error: Unable to convert string to data.")
            return nil
        }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

    var htmlStripped: String {
        return htmlToAttributedString?.string ?? self
    }
}
