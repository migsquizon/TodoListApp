

import SwiftUI

struct TaskListView: View {
  @ObservedObject var taskListVM = TaskListViewModel()
  @State var presentAddNewItem = false
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        List {
          ForEach (taskListVM.taskCellViewModels) { taskCellVM in
            TaskCell(taskCellVM: taskCellVM)
          }
          .onDelete { indexSet in
            self.taskListVM.removeTasks(atOffsets: indexSet)
          }
          if presentAddNewItem {
            TaskCell(taskCellVM: TaskCellViewModel.newTask()) { result in
              if case .success(let task) = result {
                self.taskListVM.addTask(task: task)
              }
              self.presentAddNewItem.toggle()
            }
          }
        }
        Button(action: { self.presentAddNewItem.toggle() }) {
          HStack {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 20, height: 20)
            Text("New Task")
          }
        }
        .padding()
        .accentColor(Color(UIColor.systemRed))
      }
      .navigationBarTitle("Tasks")
    }
  }
}

struct TaskListView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView()
  }
}

enum InputError: Error {
  case empty
}

struct TaskCell: View {
  @ObservedObject var taskCellVM: TaskCellViewModel
  var onCommit: (Result<Task, InputError>) -> Void = { _ in }
    @State var isOpen: Bool = false
    
    
    
  var body: some View {
    HStack {
      Image(systemName: taskCellVM.completionStateIconName)
        .resizable()
        .frame(width: 20, height: 20)
        .onTapGesture {
          self.taskCellVM.task.completed.toggle()
        }
      TextField("Enter task title", text: $taskCellVM.task.title,
                onCommit: {
                  if !self.taskCellVM.task.title.isEmpty {
                    self.onCommit(.success(self.taskCellVM.task))
                  }
                  else {
                    self.onCommit(.failure(.empty))
                  }
      }).id(taskCellVM.id)

    Button(action: {
             self.isOpen = true
         }, label: {
             Text("Date")
         }).sheet(isPresented: $isOpen, content: {
            ContentView(taskCellVM: self.taskCellVM)
         })
                     
    
    }
  
  }
}
struct ContentView: View {
    
    @ObservedObject var taskCellVM: TaskCellViewModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    @State private var dueDate = Date()
    

    var body: some View {
        VStack {
            Text("Select a due date")
            DatePicker(selection: self.$dueDate, in: Date()..., displayedComponents: .date
                       ){
                Text("")
            }
//            Text("Due date selected \($dueDate ,formatter: dateFormatter)")
            
            Button(  action: {
                self.taskCellVM.changeDate(d: self.dueDate)
                }, label: {
                    Text("Accept")}).id(taskCellVM.id)
                                
               
               }
        }
    }

