import SwiftUI

extension Button {
    func scalable() -> some View {
        buttonStyle(ScaledButtonStyle())
    }
}

private struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
