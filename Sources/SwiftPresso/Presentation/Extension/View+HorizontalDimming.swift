import SwiftUI

extension View {
    func horizontalDimming(_ edges: HorizontalEdge.Set) -> some View {
        modifier(HorizontalDimming(edges: edges))
    }
}

private struct HorizontalDimming: ViewModifier {
    let edges: HorizontalEdge.Set
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    func body(content: Content) -> some View {
        content
            .overlay {
                HStack {
                    if edges.contains(.leading) {
                        Rectangle()
                            .fill(configuration.backgroundColor)
                            .frame(width: 16)
                            .blur(radius: 4)
                    }
                    
                    Spacer()
                    
                    if edges.contains(.trailing) {
                        Rectangle()
                            .fill(configuration.backgroundColor)
                            .frame(width: 16)
                            .blur(radius: 4)
                    }
                }
            }
    }
}
