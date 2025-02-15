import SwiftUI

extension View {
    func glassEffect() -> some View {
        modifier(GlassEffectModifier())
    }
}

private struct GlassEffectModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(
                        .linearGradient(colors: [
                            .white.opacity(0.25),
                            .white.opacity(0.05),
                            .clear
                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .blur(radius: 1.3)
                
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .stroke(
                        .linearGradient(colors: [
                            .white.opacity(0.6),
                            .clear,
                            .accentColor.opacity(0.2),
                            .accentColor.opacity(0.5)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1.3
                    )
            }
        
    }
}
