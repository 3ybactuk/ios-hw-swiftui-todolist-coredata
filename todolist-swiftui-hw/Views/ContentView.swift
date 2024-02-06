import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var context

    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.dateAdded, ascending: false)]
    ) var allTasks: FetchedResults<Task>

    @State private var taskName: String = ""

    var body: some View {
        VStack {
            HStack{
                TextField("Task Name", text: $taskName)
                Button(action: {
                    self.addTask()
                }){
                    Text("Add Task")
                }
            }.padding(.horizontal, 8.0)
            List {
                ForEach(allTasks.sorted { !$0.isComplete && $1.isComplete }) { task in
                    TaskRow(task: task)
                }
            }.listRowSeparator(.visible)
        }
    }

    func addTask() {
        let newTask = Task(context: context)
        newTask.id = UUID()
        newTask.isComplete = false
        newTask.name = taskName
        newTask.dateAdded = Date()

        do {
            try context.save()
        } catch {
            print(error)
        }
        
        taskName = ""
    }
}

#Preview {
    ContentView()
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
