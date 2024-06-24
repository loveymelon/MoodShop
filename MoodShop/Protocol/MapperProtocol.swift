//
//  MapperProtocol.swift
//  MoodShop
//
//  Created by 김진수 on 6/24/24.
//

import Foundation

protocol MapperProtocol {
    associatedtype Entity
    associatedtype DTO
    
    func dtoToEntity(data: DTO) -> Entity
}
