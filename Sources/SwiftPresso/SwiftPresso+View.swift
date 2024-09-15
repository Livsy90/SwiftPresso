import SwiftUI

public extension SwiftPresso {
    
    /// View factory methods.
    enum View {
        
        public static func postList(
            host: String,
            httpScheme: HTTPScheme = .https,
            postsPerPage: Int = 50,
            tagPathComponent: String = "tag",
            categoryPathComponent: String = "category",
            isShowContentInWebView: Bool = false,
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
            categoryMenuTitle: String = "Category",
            isParseHTMLWithYouTubePreviews: Bool = true,
            isExcludeWebHeaderAndFooter: Bool = true,
            isMenuExpanded: Bool = true
        ) -> some SwiftUI.View {
            
            Configuration.configure(
                host: host,
                httpScheme: httpScheme,
                postsPerPage: postsPerPage,
                tagPathComponent: tagPathComponent,
                categoryPathComponent: categoryPathComponent,
                isShowContentInWebView: isShowContentInWebView,
                menuBackgroundColor: menuBackgroundColor,
                menuTextColor: menuTextColor,
                backgroundColor: backgroundColor,
                interfaceColor: interfaceColor,
                textColor: textColor,
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
        
        public static func postList<Placeholder: SwiftUI.View>(
            host: String,
            httpScheme: HTTPScheme = .https,
            postsPerPage: Int = 50,
            tagPathComponent: String = "tag",
            categoryPathComponent: String = "category",
            isShowContentInWebView: Bool = false,
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
            categoryMenuTitle: String = "Category",
            isParseHTMLWithYouTubePreviews: Bool = true,
            isExcludeWebHeaderAndFooter: Bool = true,
            isMenuExpanded: Bool = true,
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            
            Configuration.configure(
                host: host,
                httpScheme: httpScheme,
                postsPerPage: postsPerPage,
                tagPathComponent: tagPathComponent,
                categoryPathComponent: categoryPathComponent,
                isShowContentInWebView: isShowContentInWebView,
                menuBackgroundColor: menuBackgroundColor,
                menuTextColor: menuTextColor,
                backgroundColor: backgroundColor,
                interfaceColor: interfaceColor,
                textColor: textColor,
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
