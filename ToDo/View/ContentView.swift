import SwiftUI
import AppIntents
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Todo.upto) private var items: [Todo]
  @State var sort: Sort = .normal
  @State var onlyFirst: Bool = true
  @State var popup = false
  let vm = TodoViewModel()
  var body: some View {
    TabView {
      NavigationStack {
        let items = items.filter{ item in
          if onlyFirst {
            item.isFinished == false && item.isFirst
          } else {
            item.isFinished == false
          }
        }
        Text("")
          .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              FirstButton(onlyFirst: $onlyFirst)
            }
            ToolbarItem(placement: .topBarTrailing) {
              SortingButton(sort: $sort)
            }
            ToolbarItem(placement: .topBarTrailing) {
              CreateButton(popup: $popup)
            }
          }
        switch sort {
          case .normal:
            SectionView(items: items)
            
          case .uptoDate:
            let less1day = vm.getListFromRange(list: items, endDay: 0)
            let less1week = vm.getListFromRange(list: items, startDay: 1, endDay: 7)
            let less1month = vm.getListFromRange(list: items, startDay: 7, endDay: 30)
            if less1day.count > 0 {
              SectionView(items: less1day, text: "Today")
            }
            if less1week.count > 0 {
              SectionView(items: less1week, text: "This Week")
            }
            if less1month.count > 0 {
              SectionView(items: less1month, text: "This Month")
            }
        }
      }
      .tabItem {
        Label("Todo", systemImage: "checklist")
      }
      NavigationStack {
        Text("")
          .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              CreateButton(popup: $popup)
            }
          }
        let completedItems = items.filter {$0.isFinished == true}.sorted(by: {$0.upto < $1.upto})
        SectionView(items: completedItems)
      }
      .tabItem {
        Label("completed", systemImage: "checklist.checked")
      }
      Button {
        for i in items {
          let vm = TodoViewModel()
          i.upto = vm.getDate(date: i.upto)
        }
      } label: {
        Image(systemName: "gear")
      }
      .tabItem {
        Image(systemName: "gear")
      }
    }
    //TODO: Widget에서 사용 가능하도록 데이터 전송해야하는데...
//    .onAppear {
//      UserDefaults(suiteName: "group.Study.SwiftUI.ToDo")!.set(items, forKey: "items")
//    }
  }
  

  struct FirstButton: View {
    @Binding var onlyFirst: Bool
    var body: some View {
      Button {
        onlyFirst.toggle()
      } label: {
        Text("OnlyFirst")
      }
    }
  }
  
  struct SortingButton: View {
    @Binding var sort: Sort
    var body: some View {
      Button {
        sort.changeSorting()
      } label: {
        Image(systemName: "list.bullet.circle.fill")
          .resizable()
          .scaledToFit()
      }
    }
  }
  struct CreateButton: View {
    @Binding var popup: Bool
    var body: some View {
      Button {
        popup.toggle()
      } label: {
        Image(systemName: "plus.app.fill")
          .resizable()
          .scaledToFit()
      }
      .popover(isPresented: $popup, content: {
        CreateView(popup: $popup)
      })
    }
  }
}


#Preview {
  ContentView()
    .modelContainer(for: Todo.self, inMemory: false)
}
