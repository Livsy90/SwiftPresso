import SwiftUI

public extension SwiftPresso {
    
    /// View factory methods.
    enum View {
        
        @MainActor
        public static func postList() -> some SwiftUI.View {
            PostListCoordinator {
                ContentUnavailableView("Not Available", image: "exclamationmark.triangle")
            }

        }
        
        @MainActor
        public static func postList<ContentUnavailable: SwiftUI.View>(
            postContentUnavailableView: @escaping () -> ContentUnavailable
        ) -> some SwiftUI.View {
            PostListCoordinator(
                postContentUnavailableView: postContentUnavailableView
            )
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

extension SwiftPresso.View {
    @MainActor static func `default`() -> some View {
        SwiftPresso.configure(
            host: "livsycode.com",
            isShowContentInWebView: true
        )
        return SwiftPresso.View.postList()
    }
}

#Preview {
    SwiftPresso.View.default()
}
