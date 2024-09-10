import SwiftUI

struct SideMenu<MenuContent: View>: ViewModifier {
    @Binding var isShowing: Bool
    private let menuContent: () -> MenuContent
    
    init(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) {
        _isShowing = isShowing
        self.menuContent = menuContent
    }
    
    func body(content: Content) -> some View {
        let dragGesture = DragGesture().onEnded { event in
            if event.location.x < 200 && abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
                withAnimation {
                    isShowing = event.translation.width > 0
                }
            }
        }
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                content
                    .disabled(isShowing)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: isShowing ? geometry.size.width / 1.3 : 0)
                
                menuContent()
                    .frame(width: geometry.size.width / 1.3)
                    .transition(.move(edge: .leading))
                    .offset(x: isShowing ? 0 : -geometry.size.width / 1.3)
            }
            .gesture(dragGesture)
        }
    }
}

extension View {
    func sideMenu<MenuContent: View>(
        isShowing: Binding<Bool>,
        @ViewBuilder menuContent: @escaping () -> MenuContent
    ) -> some View {
        modifier(
            SideMenu(
                isShowing: isShowing,
                menuContent: menuContent
            )
        )
    }
}
