import SwiftUI

extension View {
    func glassStroke() -> some View {
        modifier(GlassStrokeModifier())
    }
}

private struct GlassStrokeModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        .linearGradient(colors: [
                            .white.opacity(0.6),
                            .clear,
                            .accentColor.opacity(0.2),
                            .accentColor.opacity(0.5)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.7
                    )
            }
        
    }
}
