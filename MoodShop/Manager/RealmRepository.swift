//
//  RealmRepository.swift
//  MoodShop
//
//  Created by 김진수 on 7/5/24.
//

import RealmSwift
import Foundation

final class RealmRepository: RealmProtocol {
    
    private let realm = try! Realm()
    
    func create<O: Object>(data: O) -> Result<Void, RealmError> {
        do {
            
            try realm.write {
                
                print("dd", realm.configuration.fileURL)
                realm.add(data, update: .modified)
                
            }
            
            return .success(())
            
        } catch {
            
            return .failure(.createFail)
            
        }
    }
    
    func fetch<O: Object>(type: O.Type) -> [O] {
        return Array(realm.objects(O.self))
    }
    
    func delete<O: Object>(data: O) -> Result<Void, RealmError> {
        do {
            try realm.write {
                realm.delete(data)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
    
    func deleteAll() -> Result<Void, RealmError>{
        let datas = realm.objects(SearchRequestModel.self)
        
        do {
            try realm.write {
                realm.delete(datas)
            }
            return .success(())
        } catch {
            return .failure(.deleteFail)
        }
    }
    
}
