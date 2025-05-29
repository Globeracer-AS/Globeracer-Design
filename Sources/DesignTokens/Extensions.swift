import SwiftUI

extension View {
    public func padding(_ edge: Edge.Set, _ spacing: Design.Spacing) -> some View {
        self.padding(edge, spacing.value)
    }
}

extension VStack {
    public init(alignment: HorizontalAlignment = .center, spacing: Design.Spacing? = nil, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing?.value, content: content)
    }
}

extension HStack {
    public init(alignment: VerticalAlignment = .center, spacing: Design.Spacing? = nil, @ViewBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: spacing?.value, content: content)
    }
}

extension UIColor {
    convenience init(dark: String, light: String) {
#if os(iOS) || os(tvOS)
        self.init { traits -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return UIColor(hex: dark)
            } else {
                return UIColor(hex: light)
            }
        }
#else
        self.init(hex: dark)
#endif
    }

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 8:
            (r, g, b, a) = (
                ((rgb & 0xFF000000) >> 24),
                ((rgb & 0x00FF0000) >> 16),
                ((rgb & 0x0000FF00) >> 8),
                ((rgb & 0x000000FF) >> 0)
            )
        case 6:
            (r, g, b, a) = (
                ((rgb & 0x00FF0000) >> 16),
                ((rgb & 0x0000FF00) >> 8),
                ((rgb & 0x000000FF) >> 0),
                255
            )
        default:
            // Make parse errors painful to look at
            (r, g, b, a) = (255, 0, 255, 255)
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

