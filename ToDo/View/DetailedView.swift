import SwiftUI
import SwiftData


struct DetailedView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss
  @State var item: Todo
  @State var b: Bool = false
  @State var popup: Bool = false
  @State var linkPopup: Bool = false
  var body: some View {
    VStack {
      ItemContentsView(todo: item)
      HStack {
        Spacer()
        Button {
          linkPopup.toggle()
        } label: {
          Text("Link")
        }
        .popover(isPresented: $linkPopup, content: {
          LinkView(item: item)
        })
        Button {
          for i in item.nexts {
            for j in item.pre {
              j.nexts.append(i)
              i.pre.append(j)
            }
          }
          for i in item.nexts {
            i.pre.remove(at: i.pre.firstIndex(of: item)!)
          }
          for i in item.pre {
            i.nexts.remove(at: i.nexts.firstIndex(of: item)!)
          }
          withAnimation {
            modelContext.delete(item)

            dismiss.callAsFunction()
          }
        } label: {
          Text("delete")
        }
        .padding(.trailing, 5.0)
        Button {
          popup.toggle()
        } label: {
          Text("add")
        }
        .popover(isPresented: $popup, content: {
          AddView(popup: $popup, todo: item)
        })
        Button {
          item.isFinished.toggle()
          dismiss.callAsFunction()
        } label: {
          HStack {
            Text("complete")
            Rectangle().fill(Color.clear)
              .stroke(.secondary, style: .init(lineWidth: 2.0))
              .frame(width: 20, height: 20)
              .conditionalModifier(condition: item.isFinished, content: { view in
                view.overlay(Image(systemName: "checkmark"))
              })
          }
        }
        Spacer()
      }
      Divider()
      if item.pre.isEmpty == false {
        Text("Before")
        SectionView(items: item.pre)
        Divider()
      }
      if item.nexts.count > 0 {
        Text("After")
        NavigationStack {
          SectionView(items: item.nexts)
        }
      }
      Spacer()
    }
  }
  
}


#Preview {
  struct preview: View {
    @State var item: Todo = Todo(upto: Date(), things: "asdf")
    var body: some View {
      DetailedView(item: item)
    }
  }
  return preview()
}

struct AddView: View {
  @Environment(\.modelContext) private var modelContext
  @Binding var popup: Bool
  var todo: Todo
  var newItem: Todo = Todo()
  var body: some View {
    VStack {
      ItemContentsView(todo: newItem)
      HStack {
        Button(action: {
          popup.toggle()
        }, label: {
          Text("취소")
        })
        .padding(.trailing, 10.0)
        Button(action: {
          newItem.pre.append(todo)
          todo.nexts.append(newItem)
          popup.toggle()
        }, label: {
          Text("완료")
        })
      }
    }
  }
}

struct LinkView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Todo.upto) var items: [Todo]
  var item: Todo
  var body: some View {
    List(items.filter({$0 != self.item && !self.item.nexts.contains($0)})) { item in
      GeometryReader { proxy in
        HStack {
          Toggle(isOn: Binding(get: {
            self.item.pre.contains(item)
          }, set: { newValue in
            if newValue == true {
              self.item.pre.append(item)
              item.nexts.append(self.item)
            } else {
              self.item.pre.remove(at: self.item.pre.firstIndex(of: item)!)
              item.nexts.remove(at: item.nexts.firstIndex(of: self.item)!)
            }
          }), label: {})
          .frame(width: proxy.frame(in: .local).width * 0.2, height: proxy.frame(in: .local).height, alignment: .leading)
          
          Spacer()
          RowView(item: item)
        }
      }
}
    EmptyView()
  }
}

extension View {
  @ViewBuilder func checkBox<Content: View> (
    _ condition: Bool,
    view: (Self) -> Content
  ) -> some View {
    if condition {
      view(self)
    } else {
      self
    }
  }
}
