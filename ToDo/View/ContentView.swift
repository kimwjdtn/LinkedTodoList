import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
    @Query(sort: \Todo.upto) private var items: [Todo]
  @State var sort: Sort = .normal
  @State var popup = false
  let vm = TodoViewModel()
  var body: some View {
    NavigationSplitView {
      ScrollView {
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
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            switch sort {
              case .normal:
                sort = .uptoDate
              case .uptoDate:
                sort = .normal
            }
          } label: {
            Image(systemName: "list.bullet.circle.fill")
              .resizable()
              .scaledToFit()
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
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
    } detail: {
      Text("")
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Todo.self, inMemory: false)
}

struct LinkView: View {
  var item: Todo
  var body: some View {
    NavigationLink(
      destination: DetailedView(item: item),
      label: {
        HStack {
          RowView(item: item)
            .padding(.horizontal, 3.0)
            .padding(.vertical , 5.0)
        }
      })
    
  }
}

struct RowView: View {
  let vm = TodoViewModel()
  var item: Todo
  var body: some View {
    GeometryReader { proxy in
      HStack {
        Circle()
          .fill(.black)
          .padding(.leading, 5.0)
        let (txt, date) = vm.getFormed(item: item)
        HStack {
          Text(txt)
            .frame(width: proxy.size.width * 0.6)
          Text(date)
            .frame(width: proxy.size.width * 0.3)
        }
        .padding(.horizontal, 3)
        .overlay {
          StrokeShapeView(shape: RoundedRectangle(cornerRadius: 15.0), style: Color.black, strokeStyle: StrokeStyle(lineWidth: 2.0), isAntialiased: false, background: EmptyView())
        }
        .background(.gray.opacity(0.1))
      }
    }
  }
}

struct SectionView: View {
  @Environment(\.modelContext) private var modelContext
  var items: [Todo]
  var text = ""
  var body: some View {
    Text(text)
      .padding(.top, 10.0)
    ForEach(items) {item in
      LinkView(item: item)
    }
  }
}
