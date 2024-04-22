//
//  TaskStore.swift
//  Focus
//
//  Created by XREAL on 2024/4/22.
//

import Foundation
import WidgetKit

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    
    init() {
        if let data = UserDefaults(suiteName: "group.com.xd.Focus")?.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decodedTasks
        } else {
            tasks = []
        }
    }

    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()  // 在添加任务后立即保存
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
        saveTasks()  // 在添加任务后立即保存
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll(where: { $0.id == task.id })
        saveTasks()  // 在添加任务后立即保存
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        updateTasksOrder()
        saveTasks()  // 在添加任务后立即保存
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    func updateTasksOrder() {
        for i in 0..<tasks.count {
            tasks[i].order = i
        }
    }
    
    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults(suiteName: "group.com.xd.Focus")?.set(data, forKey: "tasks")
        }
    }
}
