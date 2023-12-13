import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Todo.upto) private var items: [Todo]
  @State var sort: Sort = .normal
  @State var popup = false
  let vm = TodoViewModel()
  var body: some View {
    TabView {
      NavigationStack {
        let items = items.filter{$0.isFinished == false && $0.isFirst}
        Text("")
          .toolbar {
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
            let less1day = items.filter {$0.upto < Date(timeIntervalSinceNow: 86400) }
            let less1week = items.filter { Calendar.current.date(byAdding: .day, value: 1, to: Date())! ... Calendar.current.date(byAdding: .day, value: 7, to: Date())! ~= $0.upto
            }
            let less1month = items.filter {
              Calendar.current.date(byAdding: .day, value: 7, to: Date())! ... Calendar.current.date(byAdding: .day, value: 30, to: Date())! ~= $0.upto
            }
            if less1day.count > 0 {
              SectionView(items: less1day, text: "Today")
            }
            if less1week.count > 0 {
              SectionView(items: less1week, text: "This Week")
            }
            if less1month.count > 0 {
              SectionView(items: less1month, text: "This Month")
            }
            
          case .allUnFinished:
            let items = self.items.filter { !$0.isFinished }
            SectionView(items: items)
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

