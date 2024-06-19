//
//  HomeRepositoryProtocol.swift
//  MoodShop
//
//  Created by 김진수 on 6/12/24.
//

import Foundation

protocol HomeRepositoryProtocol {
    func fetchSearch(text: String, display: String) async
}

