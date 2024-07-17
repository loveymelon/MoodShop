//
//  RealmProtocol.swift
//  MoodShop
//
//  Created by 김진수 on 7/5/24.
//

import Foundation
import RealmSwift

protocol RealmProtocol {
    func create<O: Object>(data: O) -> Result<Void, RealmError>
    func fetch<O: Object>(type: O.Type) -> [O]
    func delete<O: Object>(data: O, type: O.Type, id: String) -> Result<Void, RealmError>
}
