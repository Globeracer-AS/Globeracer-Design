import SwiftUI

extension View {
    public func padding(_ edge: Edge.Set, _ spacing: Design.Spacing) -> some View {
        self.padding(edge, spacing.value)
    }
}
