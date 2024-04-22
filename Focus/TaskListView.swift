//
//  TaskStoreView.swift
//  Focus
//
//  Created by XREAL on 2024/4/22.
//

import Foundation
import SwiftUI

struct TaskListView: View {
    @StateObject private var taskStore = TaskStore()
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(taskStore.tasks) { task in
                        TaskRowView(task: task, onToggleCompletion: toggleTaskCompletion)
                    }
                    .onDelete(perform: deleteTask)
                    .onMove(perform: move)
                }
                .listStyle(PlainListStyle())
                
                HStack {
                    TextField("New Task", text: $newTaskTitle)
                    Button(action: addTask) {
                        Text("Add")
                    }
                }
                .padding()
            }
            .navigationTitle("Tasks")
        }
    }
    
    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = Task(title: newTaskTitle, order: taskStore.tasks.count)
        taskStore.addTask(newTask)
        newTaskTitle = ""
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = taskStore.tasks[index]
            taskStore.deleteTask(task)
        }
    }
    
    private func toggleTaskCompletion(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        taskStore.updateTask(updatedTask)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        taskStore.tasks.move(fromOffsets: source, toOffset: destination)
    }
}
