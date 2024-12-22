import SwiftUI

public extension SwiftPresso {
    
    /// View factory methods.
    enum View {
        
        @MainActor
        public static func postList() -> some SwiftUI.View {
            PostListCoordinator(placeholder: nil)
        }
        
        @MainActor
        public static func postList<Placeholder: SwiftUI.View>(
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            PostListCoordinator(placeholder: placeholder)
        }
        
        @MainActor
        public static func profileView<BottomContent: SwiftUI.View>(
            bottomContent: @escaping () -> BottomContent
        ) -> some SwiftUI.View {
            ProfileView(bottomContent: bottomContent)
        }
        
        @MainActor
        public static func profileView() -> some SwiftUI.View {
            ProfileView()
        }
        
    }
    
}
