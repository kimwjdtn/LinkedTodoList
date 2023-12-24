import SwiftUI
import SwiftData

struct RowView: View {
  @State private var isDragging = false
  let vm = TodoViewModel()
  var item: Todo
  var drag: some Gesture {
    DragGesture()
      .onChanged {_ in self.isDragging = true; print("on") }
      .onEnded{ _ in self.isDragging = false; print("off") }
  }
  var body: some View {
    let (txt, date) = vm.getFormed(item: item)
    GeometryReader { proxy in
      HStack {
        Text(txt)
          .frame(width: proxy.frame(in: .local).width * 0.7, height: proxy.frame(in: .local).height, alignment: .leading)
        Text(date)
          .frame(width: proxy.frame(in: .local).width * 0.3, height: proxy.frame(in: .local).height, alignment: .leading)
          .minimumScaleFactor(0.5)
      }
      .lineLimit(1)
      .gesture(drag)
    }
  }
}

#Preview {
  struct preview: View {
    let items = [Todo(upto: Date(), things: "5"), Todo(upto: Date(), things: "2"), Todo(upto: Date(), things: "3")]
    var body: some View {
      SectionView(items: items)
    }
  }
  return preview()
}

struct SectionView: View {
  let items: [Todo]
  var text = ""
  var body: some View {
    let items = items.sorted { a, b in
      if a.upto < b.upto {
        return true
      } else if a.upto > b.upto {
        return false
      } else {
        let a = a.things[a.things.startIndex]
        let b = b.things[b.things.startIndex]
        return a < b
      }
    }
    if !text.isEmpty {
      Text(text)
    }
    List(items) { item in
      NavigationLink(destination: DetailedView(item: item), label: {RowView(item: item)})
    }
    .navigationDestination(for: Todo.self, destination: {DetailedView(item: $0)})
  }
}
