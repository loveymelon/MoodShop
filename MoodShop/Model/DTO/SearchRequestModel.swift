//
//  SearchRequestModel.swift
//  MoodShop
//
//  Created by 김진수 on 7/12/24.
//

import Foundation
import RealmSwift

class SearchRequestModel: Object {
    @Persisted(primaryKey: true) var id: String
    
    @Persisted var title: String
    
    convenience init(title: String) {
        self.init()
        
        self.title = title
    }
}
