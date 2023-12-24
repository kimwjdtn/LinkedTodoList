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
  
  func getDate(date: Date) -> Date {
    Calendar.current.startOfDay(for: date)
  }
  
  /// 날짜 범위에 들어가 있는 할일들
  /// - Parameters:
  ///   - list: [할일]
  ///   - startDay: 오늘로부터 며칠 후 시작일
  ///   - endDay: 오늘로부터 며칠 후 종료일
  /// - Returns: 사이에 포함되는 할일들
  func getListFromRange(
    list: [Todo],
    startDay: Int? = nil,
    endDay: Int? = nil
  ) -> [Todo] {
    let start = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: startDay ?? 0, to: Date())!)
    let end = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: endDay ?? 0, to: Date())!)
    guard startDay != nil || endDay != nil else {
      return list
    }
    if startDay == nil {
      return list.filter { $0.upto <= end }
    } else if endDay == nil {
      return list.filter { $0.upto >= start }
    } else {
      return list.filter {start ..< end ~= $0.upto}
    }
  }
  
  init() {
    self.dateFormat.dateFormat = "yyyy-MM-dd"
  }
}

enum Sort {
  case normal
  case uptoDate
  
  
  mutating func changeSorting() {
    switch self {
      case .normal:
        self = .uptoDate
      case .uptoDate:
        self = .normal
    }
  }
}
