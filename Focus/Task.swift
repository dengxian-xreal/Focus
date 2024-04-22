//
//  Task.swift
//  Focus
//
//  Created by XREAL on 2024/4/22.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var order: Int
    
    init(title: String, order: Int) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.order = order
    }
}
