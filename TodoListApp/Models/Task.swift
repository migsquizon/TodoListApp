

import Foundation

enum TaskPriority: Int, Codable {
  case high
  case medium
  case low
}

struct Task: Codable, Identifiable {
  var id: String = UUID().uuidString
  var title: String
  var priority: TaskPriority
  var completed: Bool
    var date: Date
}
//extension NSDate
//{
//    convenience init(_ dateString:String) {
//      let dateStringFormatter = DateFormatter()
//      dateStringFormatter.dateFormat = "yyyy-MM-dd"
//        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
//        let d = dateStringFormatter.date(from: dateString)!
//        self.init(timeInterval:0, since:d)
//    }
// }


var dateFormatter: DateFormatter {
     let formatter = DateFormatter()
     formatter.dateStyle = .long
     return formatter
 }

var dueDate = Date()

#if DEBUG
let testDataTasks = [
    Task(title: "Implement UI", priority: .medium, completed: true,date:dueDate),

]
#endif
