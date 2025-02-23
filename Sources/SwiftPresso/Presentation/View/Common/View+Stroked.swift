import SwiftUI

extension View {
    func stroked() -> some View {
        modifier(StrokeModifier())
    }
}

private struct StrokeModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
            }
        
    }
}
