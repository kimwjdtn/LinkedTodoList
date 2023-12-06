import SwiftUI

struct CreateView: View {
  @Environment(\.modelContext) private var modelContext
  @Binding var popup: Bool
  @State var todo: Todo = Todo()
  var body: some View {
    VStack {
      ItemContentsView(todo: todo)
      HStack {
        Button(action: {
          popup.toggle()
        }, label: {
          Text("취소")
        })
        .padding(.trailing, 10.0)
        Button(action: {
          modelContext.insert(todo)
          popup.toggle()
        }, label: {
          Text("완료")
        })
      }
    }
  }
}

#Preview {
  struct Previews: View {
    @State var b: Bool = true
    var body: some View {
      CreateView(popup: $b)
    }
  }
  return Previews()
}

struct ItemContentsView: View {
  var todo: Todo
  var body: some View {
    VStack {
      TextField(text: Binding(get: {
        todo.things
      }, set: { newValue in
        todo.things = newValue
      })) {
        Text("TodoThings")
      }
      DatePicker("Choose", selection: Binding(get: {
        todo.upto
      }, set: { newValue in
        todo.upto = newValue
      }), displayedComponents: .date)
    }
    .padding([.leading,.trailing], 10.0)
  }
}
