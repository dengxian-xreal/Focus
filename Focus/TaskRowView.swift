//
//  TaskRowView.swift
//  Focus
//
//  Created by XREAL on 2024/4/22.
//

import Foundation
import SwiftUI

struct TaskRowView: View {
    var task: Task
    var onToggleCompletion: (Task) -> Void
    
    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            Button(action: {
                onToggleCompletion(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
        }
    }
}
