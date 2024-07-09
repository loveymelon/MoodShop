//
//  RealmError.swift
//  MoodShop
//
//  Created by 김진수 on 7/5/24.
//

import Foundation

enum RealmError: Error {
    case createFail
    case updateFail(text: String)
    case deleteFail
    case unknownError
    
    var description: String {
        switch self {
        case .createFail:
            return "createFail"
        case .updateFail(let text):
            return text
        case .deleteFail:
            return "deleteFail"
        case .unknownError:
            return "unknownError"
        }
    }
}
