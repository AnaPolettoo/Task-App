//
//  Task.swift
//  LogAccount3
//
//  Created by Ana Carolina Palhares Poletto on 06/05/25.
//

import Foundation

struct Task: Codable {
    var id = UUID()
    let name: String
    let category: Category
    let description: String
    var isDone: Bool = false
}
