//
//  TaskListView.swift
//  Focus
//
//  Created by XREAL on 2024/4/22.
//

import Foundation
import SwiftUI
import WidgetKit

struct TaskListView: View {
    @StateObject private var taskStore = TaskStore()
        @State private var newTaskTitle = ""
        
        var body: some View {
            NavigationView {
                VStack {
                    List {
                        let uncompletedTasks = taskStore.tasks.filter { !$0.isCompleted }
                        let completedTasks = taskStore.tasks.filter { $0.isCompleted }
                        
                        ForEach(uncompletedTasks) { task in
                            TaskRowView(task: task, onToggleCompletion: toggleTaskCompletion)
                        }
                        .onDelete { indexSet in
                            deleteTask(at: indexSet, inCompleted: false)
                        }
                        .onMove { source, destination in
                            move(from: source, to: destination, inCompleted: false)
                        }
                        
                        if !completedTasks.isEmpty {
                            Section(header: Text("Completed Tasks")) {
                                ForEach(completedTasks) { task in
                                    TaskRowView(task: task, onToggleCompletion: toggleTaskCompletion)
                                }
                                .onDelete { indexSet in
                                    deleteTask(at: indexSet, inCompleted: true)
                                }
                                .onMove { source, destination in
                                    move(from: source, to: destination, inCompleted: true)
                                }
                            }
                        }
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
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    private func deleteTask(at offsets: IndexSet, inCompleted: Bool) {
        let tasksToDelete = inCompleted ? taskStore.tasks.filter { $0.isCompleted } : taskStore.tasks.filter { !$0.isCompleted }
        offsets.forEach { index in
            let task = tasksToDelete[index]
            taskStore.deleteTask(task)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    private func toggleTaskCompletion(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        taskStore.updateTask(updatedTask)
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
    }
    
    private func move(from source: IndexSet, to destination: Int, inCompleted: Bool) {
        let tasksToMove = inCompleted ? taskStore.tasks.filter { $0.isCompleted } : taskStore.tasks.filter { !$0.isCompleted }
        let sourceTasks = source.map { tasksToMove[$0] }
        let destinationIndex = tasksToMove.firstIndex(where: { $0.id == tasksToMove[destination].id })!

        for task in sourceTasks {
            if let index = taskStore.tasks.firstIndex(where: { $0.id == task.id }) {
                taskStore.tasks.remove(at: index)
                taskStore.tasks.insert(task, at: taskStore.tasks.firstIndex(where: { $0.id == tasksToMove[destinationIndex].id }) ?? 0)
            }
        }

        taskStore.updateTasksOrder()
        WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
        
        print("Uncompleted tasks after move (in TaskListView):")
        for (index, task) in taskStore.tasks.enumerated() where !task.isCompleted {
            print("Task \(index): \(task.title)")
        }
    }
}
