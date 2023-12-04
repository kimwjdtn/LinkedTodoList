//TODO: 모든 정렬은 날짜순으로
//TODO: 하나를 제거하면 그거에 연결된것들을 데이터베이스에 추가하고 제거

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Todo]
  var body: some View {
    ZStack {
      
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Todo.self, inMemory: false)
}
