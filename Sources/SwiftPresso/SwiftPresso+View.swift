import SwiftUI

public extension SwiftPresso {
    
    /// View factory methods.
    enum View {
        
        @MainActor
        public static func postList() -> some SwiftUI.View {
            PostListCoordinator {
                ShimmerPlaceholder()
            } postContentUnavailableView: {
                ContentUnavailableView("Not Available", image: "exclamationmark.triangle")
            }

        }
        
        @MainActor
        public static func postList<Placeholder: SwiftUI.View>(
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            PostListCoordinator(placeholder: placeholder) {
                ContentUnavailableView("Not Available", image: "exclamationmark.triangle")
            }
        }
        
        @MainActor
        public static func postList<Placeholder: SwiftUI.View, ContentUnavailable: SwiftUI.View>(
            placeholder: @escaping () -> Placeholder,
            postContentUnavailableView: @escaping () -> ContentUnavailable
        ) -> some SwiftUI.View {
            PostListCoordinator(
                placeholder: placeholder,
                postContentUnavailableView: postContentUnavailableView
            )
        }
        
        @MainActor
        public static func postList<ContentUnavailable: SwiftUI.View>(
            postContentUnavailableView: @escaping () -> ContentUnavailable
        ) -> some SwiftUI.View {
            PostListCoordinator {
                ShimmerPlaceholder()
            } postContentUnavailableView: {
                postContentUnavailableView()
            }
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
