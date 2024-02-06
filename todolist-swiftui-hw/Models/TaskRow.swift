import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task
    @State private var editedTaskName: String = ""
    @State private var isEditing: Bool = false

    init(task: Task) {
        self.task = task
        self._editedTaskName = State(initialValue: task.name ?? "")
    }
    
    var body: some View {
        HStack {
            Button(action: {
                // Toggle task completion status
                self.task.isComplete.toggle()
                do {
                    try task.managedObjectContext?.save()
                } catch {
                    print("Error toggling task completion status: \(error.localizedDescription)")
                }
            }) {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isComplete ? .green : .blue)
            }
            .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove button styling
            
            TextField("Task Name", text: $editedTaskName, onCommit: {
                task.name = editedTaskName
                do {
                    try task.managedObjectContext?.save()
                } catch {
                    print("Error saving edited task name: \(error.localizedDescription)")
                }
            })
            .foregroundColor(task.isComplete ? .gray : .black)
            
            Spacer()
            
            Button(action: {
                // Delete task
                task.managedObjectContext?.delete(task)
                do {
                    try task.managedObjectContext?.save()
                } catch {
                    print("Error deleting task: \(error.localizedDescription)")
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove button styling
        }
        .padding()
    }
}
