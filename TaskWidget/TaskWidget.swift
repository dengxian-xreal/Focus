import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let tasks = TaskStore.shared.tasks
        let entry = SimpleEntry(date: Date(), tasks: tasks)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let tasks = TaskStore.shared.tasks
        let entry = SimpleEntry(date: Date(), tasks: tasks)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
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
                    TaskStore.shared.completeTask(firstTask)
                    WidgetCenter.shared.reloadTimelines(ofKind: "TaskWidget")
                }) {
                    Text("Complete")
                        .foregroundColor(.blue)
                }
            }
            .padding()
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



