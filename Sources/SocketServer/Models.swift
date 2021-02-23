//
//  File.swift
//  
//
//  Created by Nicholas Ryan Taylor on 2021/02/23.
//

import Foundation

struct Result: Decodable {
    let total: String
    let matrix: [[Int]]
}

struct Board: Encodable, Identifiable {
    let date = Date()
    let id = UUID()
    let matrix: [[Int]]
}
