//
//  ContainerProtocol.swift
//  MoodShop
//
//  Created by 김진수 on 6/10/24.
//

import Foundation

protocol ContainerProtocol {
    associatedtype Intent
    associatedtype State
    
    var state: State { get }
    
    func send(_ intent: Intent)
}
