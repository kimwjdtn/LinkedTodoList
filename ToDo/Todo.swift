import Foundation
import SwiftData

@Model
class Todo {
  @Attribute(.unique) let uuid = UUID()
  var isFirst: Bool {
    get {
      if self.pre.isEmpty {
        return true
      } else {
        return self.pre.allSatisfy({ pres in pres.isFinished })
      }
    }
  }
  var upto: Date
  var things: String
  var nexts: [Todo] = [Todo]()
  var pre: [Todo] = [Todo]()
  var isFinished = false
  
  init(upto: Date, things: String, next: Todo? = nil, pre: [Todo] = []) {
    self.upto = upto
    self.things = things
    self.pre = pre
    if let next = next {
      self.nexts.append(next)
    }
  }
  
  init() {
    self.upto = Date()
    self.things = ""
    self.pre = []
  }
}

struct TodoViewModel {
  let dateFormat = DateFormatter()
  var sort = Sort.normal
  func getFormed(item: Todo) -> (String, String) {
    let txt = item.things
    let date = dateFormat.string(from: item.upto)
    return (txt, date)
  }
  func getLinked(todo: Todo) -> [Todo] {
    var list = [Todo]()
    func inner(_ inside: Todo) {
      list.append(inside)
      for i in inside.nexts {
        inner(i)
      }
    }
    inner(todo)
    for i in list {
      print(i.things)
    }
    return list
  }
  init() {
    self.dateFormat.dateFormat = "yyyy-MM-dd"
    
  }
}

enum Sort {
  case normal
  case uptoDate
  case allUnFinished
  
  
  mutating func changeSorting() {
    switch self {
      case .normal:
        self = .uptoDate
      case .uptoDate:
        self = .allUnFinished
      case .allUnFinished:
        self = .normal
    }
  }
}
