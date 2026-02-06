import SwiftUI

enum AppStyle {
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 20
    }

    enum Radius {
        static let medium: CGFloat = 12
    }

    enum Fonts {
        static let title: Font = .headline
        static let body: Font = .body
        static let button: Font = .headline
    }
}

struct FieldBackground: ViewModifier {
    var corner: CGFloat = AppStyle.Radius.medium

    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .padding(.horizontal, AppStyle.Spacing.medium)
            .padding(.vertical, AppStyle.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    func fieldBackground(corner: CGFloat = AppStyle.Radius.medium) -> some View {
        self.modifier(FieldBackground(corner: corner))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var corner: CGFloat = AppStyle.Radius.medium

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppStyle.Fonts.button)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppStyle.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(Color.accentColor.opacity(configuration.isPressed ? 0.85 : 1.0))
            )
            .foregroundStyle(.white)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}
