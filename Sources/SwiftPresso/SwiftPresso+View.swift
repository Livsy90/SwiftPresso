import SwiftUI

public extension SwiftPresso {
    
    /// View factory methods.
    enum View {
        
        @MainActor
        public static func postList(
            host: String,
            httpScheme: HTTPScheme = .https,
            postsPerPage: Int = 50,
            tagPathComponent: String = "tag",
            categoryPathComponent: String = "category",
            isShowContentInWebView: Bool = false,
            isShowFeaturedImage: Bool = true,
            menuBackgroundColor: Color = .primary,
            menuTextColor: Color = Color(uiColor: .systemBackground),
            backgroundColor: Color = Color(uiColor: .systemBackground),
            interfaceColor: Color = .primary,
            textColor: Color = .primary,
            homeIcon: Image = Image(systemName: "house"),
            homeTitle: String = "Home",
            searchTitle: String = "Search",
            isShowPageMenu: Bool = true,
            isShowTagMenu: Bool = true,
            isShowCategoryMenu: Bool = true,
            pageMenuTitle: String = "Pages",
            tagMenuTitle: String = "Tags",
            categoryMenuTitle: String = "Categories",
            isParseHTMLWithYouTubePreviews: Bool = true,
            isExcludeWebHeaderAndFooter: Bool = true,
            isMenuExpanded: Bool = true
        ) -> some SwiftUI.View {
            
            configure(
                host: host,
                httpScheme: httpScheme,
                postsPerPage: postsPerPage,
                tagPathComponent: tagPathComponent,
                categoryPathComponent: categoryPathComponent,
                isShowContentInWebView: isShowContentInWebView,
                isShowFeaturedImage: isShowFeaturedImage,
                backgroundColor: backgroundColor,
                interfaceColor: interfaceColor,
                textColor: textColor, 
                menuBackgroundColor: menuBackgroundColor,
                menuTextColor: menuTextColor,
                homeIcon: homeIcon,
                homeTitle: homeTitle,
                searchTitle: searchTitle,
                isShowPageMenu: isShowPageMenu,
                isShowTagMenu: isShowTagMenu,
                isShowCategoryMenu: isShowCategoryMenu,
                pageMenuTitle: pageMenuTitle,
                tagMenuTitle: tagMenuTitle,
                categoryMenuTitle: categoryMenuTitle,
                isParseHTMLWithYouTubePreviews: isParseHTMLWithYouTubePreviews,
                isExcludeWebHeaderAndFooter: isExcludeWebHeaderAndFooter,
                isMenuExpanded: isMenuExpanded
            )
            
            return PostListCoordinator(placeholder: nil)
        }
        
        @MainActor
        public static func postList<Placeholder: SwiftUI.View>(
            host: String,
            httpScheme: HTTPScheme = .https,
            postsPerPage: Int = 50,
            tagPathComponent: String = "tag",
            categoryPathComponent: String = "category",
            isShowContentInWebView: Bool = false,
            isShowFeaturedImage: Bool = true,
            menuBackgroundColor: Color = .primary,
            menuTextColor: Color = Color(uiColor: .systemBackground),
            backgroundColor: Color = Color(uiColor: .systemBackground),
            interfaceColor: Color = .primary,
            textColor: Color = .primary,
            homeIcon: Image = Image(systemName: "house"),
            homeTitle: String = "Home",
            searchTitle: String = "Search",
            isShowPageMenu: Bool = true,
            isShowTagMenu: Bool = true,
            isShowCategoryMenu: Bool = true,
            pageMenuTitle: String = "Pages",
            tagMenuTitle: String = "Tags",
            categoryMenuTitle: String = "Categories",
            isParseHTMLWithYouTubePreviews: Bool = true,
            isExcludeWebHeaderAndFooter: Bool = true,
            isMenuExpanded: Bool = true,
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            
            configure(
                host: host,
                httpScheme: httpScheme,
                postsPerPage: postsPerPage,
                tagPathComponent: tagPathComponent,
                categoryPathComponent: categoryPathComponent,
                isShowContentInWebView: isShowContentInWebView,
                isShowFeaturedImage: isShowFeaturedImage,
                backgroundColor: backgroundColor,
                interfaceColor: interfaceColor, 
                textColor: textColor, 
                menuBackgroundColor: menuBackgroundColor,
                menuTextColor: menuTextColor,
                homeIcon: homeIcon,
                homeTitle: homeTitle,
                searchTitle: searchTitle,
                isShowPageMenu: isShowPageMenu,
                isShowTagMenu: isShowTagMenu,
                isShowCategoryMenu: isShowCategoryMenu,
                pageMenuTitle: pageMenuTitle,
                tagMenuTitle: tagMenuTitle,
                categoryMenuTitle: categoryMenuTitle,
                isParseHTMLWithYouTubePreviews: isParseHTMLWithYouTubePreviews,
                isExcludeWebHeaderAndFooter: isExcludeWebHeaderAndFooter,
                isMenuExpanded: isMenuExpanded
            )
            
            return PostListCoordinator(placeholder: placeholder)
        }
        
    }
    
}
