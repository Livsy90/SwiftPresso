import SwiftUI

extension View {
    func readSize(_ size: Binding<CGSize>, isStatic: Bool = true) -> some View {
        modifier(HeightReader(size: size, isStatic: isStatic))
    }
}

private struct HeightReader: ViewModifier {
    @Binding var size: CGSize
    let isStatic: Bool
    @State private var didSetSize: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newValue in
                guard size.width != newValue.width, size.height != newValue.height else { return }
                if isStatic {
                    guard !didSetSize else { return }
                    size = newValue
                    didSetSize = true
                } else {
                    size = newValue
                }
            }
    }
}
