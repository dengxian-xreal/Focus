import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if let data = UserDefaults(suiteName: "group.com.xd.Focus")?.data(forKey: "tasks"),
           let tasks = try? JSONDecoder().decode([Task].self, from: data) {
            let entry = SimpleEntry(date: Date(), tasks: tasks)
            completion(entry)
        } else {
            let entry = SimpleEntry(date: Date(), tasks: [])
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        if let data = UserDefaults(suiteName: "group.com.xd.Focus")?.data(forKey: "tasks"),
           let tasks = try? JSONDecoder().decode([Task].self, from: data) {
            let entry = SimpleEntry(date: Date(), tasks: tasks)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        } else {
            let entry = SimpleEntry(date: Date(), tasks: [])
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let tasks: [Task]
}

struct TaskWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if entry.tasks.isEmpty {
            Text("Great! You finish them all!")
                .padding()
        } else {
            let firstTask = entry.tasks[0]
            VStack {
                Text(firstTask.title)
                    .font(.headline)
                Button(action: {
                    completeTask(firstTask)
                    WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
                }) {
                    Text("Complete")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }

    func completeTask(_ task: Task) {
        if let data = UserDefaults(suiteName: "group.com.xd.Focus")?.data(forKey: "tasks"),
           var tasks = try? JSONDecoder().decode([Task].self, from: data),
           let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = true
            if let updatedData = try? JSONEncoder().encode(tasks) {
                UserDefaults(suiteName: "group.com.xd.Focus")?.set(updatedData, forKey: "tasks")
            }
        }
    }
}

struct TaskWidget: Widget {
    let kind: String = "TaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Task Widget")
        .description("Display your first task and mark it as complete.")
    }
}



