import SwiftUI

extension SwiftPresso {
    
    /// View factory methods.
    public enum View {
        
        public static func postListView<Placeholder: SwiftUI.View>(
            _ configuration: SwiftPressoConfiguration,
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            Configuration.configure(with: configuration)
            
            return PostListView(
                backgroundColor: Configuration.backgroundColor,
                interfaceColor: Configuration.interfaceColor,
                textColor: Configuration.textColor,
                menuBackgroundColor: Configuration.menuBackgroundColor,
                menuTextColor: Configuration.menuTextColor,
                homeIcon: Configuration.homeIcon,
                isShowPageMenu: Configuration.isShowPageMenu,
                isShowTagMenu: Configuration.isShowTagMenu,
                isShowCategoryMenu: Configuration.isShowCategoryMenu,
                pageMenuTitle: Configuration.pageMenuTitle,
                tagMenuTitle: Configuration.tagMenuTitle,
                categoryMenuTitle: Configuration.categoryMenuTitle,
                postPerPage: Configuration.postsPerPage,
                loadingPlaceholder: placeholder
            )
        }
        
        public static func shimmerPlaceholderView(backgroundColor: Color = Configuration.backgroundColor) -> some SwiftUI.View {
            SPShimmerPlacehodler(backgroundColor: backgroundColor)
        }
        
    }
    
}
