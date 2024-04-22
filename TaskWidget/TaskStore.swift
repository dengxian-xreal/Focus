//
//  TaskStore.swift
//  TaskWidgetExtension
//
//  Created by XREAL on 2024/4/22.
//

import Foundation
import WidgetKit

class TaskStore {
    static let shared = TaskStore()
    
    var tasks: [Task] = []
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll(where: { $0.id == task.id })
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        updateTasksOrder()
    }
    
    func completeTask(_ task: Task) {
        deleteTask(task)
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    private func updateTasksOrder() {
        for i in 0..<tasks.count {
            tasks[i].order = i
        }
    }
}
