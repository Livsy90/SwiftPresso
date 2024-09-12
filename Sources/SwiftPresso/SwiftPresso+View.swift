import SwiftUI

extension SwiftPresso {
    
    /// View factory methods.
    public enum View {
        
        public static func postList(_ configuration: SwiftPressoSettings) -> some SwiftUI.View {
            PostListCoordinator(configuration: configuration, placeholder: nil)
        }
        
        public static func postList<Placeholder: SwiftUI.View>(
            _ configuration: SwiftPressoSettings,
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            PostListCoordinator(configuration: configuration, placeholder: placeholder)
        }
        
        static func _postList(_ configuration: SwiftPressoSettings) -> some SwiftUI.View {
            Configuration.configure(with: configuration)
            
            return PostListView(
                backgroundColor: Configuration.backgroundColor,
                interfaceColor: Configuration.interfaceColor,
                textColor: Configuration.textColor,
                menuBackgroundColor: Configuration.menuBackgroundColor,
                menuTextColor: Configuration.menuTextColor,
                homeIcon: Configuration.homeIcon, 
                isShowContentInWebView: Configuration.isShowContentInWebView,
                isShowPageMenu: Configuration.isShowPageMenu,
                isShowTagMenu: Configuration.isShowTagMenu,
                isShowCategoryMenu: Configuration.isShowCategoryMenu, 
                isMenuExpanded: Configuration.isMenuExpanded,
                pageMenuTitle: Configuration.pageMenuTitle,
                tagMenuTitle: Configuration.tagMenuTitle,
                categoryMenuTitle: Configuration.categoryMenuTitle,
                postPerPage: Configuration.postsPerPage,
                loadingPlaceholder: {
                    ShimmerPlaceholder(backgroundColor: Configuration.backgroundColor)
                }
            )
        }
        
        static func _postListWithCustomPlaceholder<Placeholder: SwiftUI.View>(
            _ configuration: SwiftPressoSettings,
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
                isShowContentInWebView: Configuration.isShowContentInWebView,
                isShowPageMenu: Configuration.isShowPageMenu,
                isShowTagMenu: Configuration.isShowTagMenu,
                isShowCategoryMenu: Configuration.isShowCategoryMenu,
                isMenuExpanded: Configuration.isMenuExpanded,
                pageMenuTitle: Configuration.pageMenuTitle,
                tagMenuTitle: Configuration.tagMenuTitle,
                categoryMenuTitle: Configuration.categoryMenuTitle,
                postPerPage: Configuration.postsPerPage,
                loadingPlaceholder: placeholder
            )
        }
        
    }
    
}
