import SwiftUI


struct DetailedView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss
  @State var item: Todo
  @State var b: Bool = false
  @State var popup: Bool = false
  var body: some View {
    VStack {
      ItemContentsView(todo: item)
      HStack {
        Spacer()
        Button {
          for i in item.nexts {
            item.pre?.nexts.append(i)
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
        Spacer()
      }
      Divider()
      if item.pre != nil {
        Text("Before")
        LinkView(item: item.pre!)
        Divider()
      }
      if item.nexts.count > 0 {
        Text("After")
        NavigationStack {
          ForEach(item.nexts) {i in
            LinkView(item: i)
          }
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
          newItem.pre = todo
          todo.nexts.append(newItem)
          popup.toggle()
        }, label: {
          Text("완료")
        })
      }
    }
  }
}
