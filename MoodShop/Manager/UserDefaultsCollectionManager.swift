//
//  UserDefaultsCollectionManager.swift
//  MoodShop
//
//  Created by 김진수 on 7/4/24.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?
    
    let mapper: UserDefaultsMapper
    
    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
        self.mapper = UserDefaultsMapper()
    }
    
    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
}

extension UserDefaultWrapper {
//    @UserDefaultWrapper(key: "LikeSet", defaultValue: nil)
//    static var likeItems: String
}
