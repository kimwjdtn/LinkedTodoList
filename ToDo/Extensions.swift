import Foundation
import SwiftUI

extension View {
  @ViewBuilder func conditionalModifier<Content: View>(condition: Bool, content: (Self) -> Content) -> some View {
    if condition {
      content(self)
    } else {
      self
    }
  }
}
