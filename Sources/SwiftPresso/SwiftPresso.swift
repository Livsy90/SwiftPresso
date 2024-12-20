import SwiftUI

public enum SwiftPresso {
    
    /// Initial configuration.
    /// - Parameters:
    ///   - host: API host.
    ///   - httpScheme: API HTTP scheme.
    ///   - postsPerPage: Posts per page in the post list request.
    ///   - tagPathComponent: API Tag path component.
    ///   - categoryPathComponent: API Category path component.
    ///   - isShowContentInWebView: Using WKWebView as post view.
    ///   - isShowFeaturedImage: Post featured image visibility.
    ///   - backgroundColor: Post list and post view background color.
    ///   - interfaceColor: Post list and post view interface color.
    ///   - textColor: Post list and post view text color.
    ///   - postListFont: Post list font.
    ///   - postBodyFont: Post body font.
    ///   - postTitleFont: Post title font.
    ///   - menuBackgroundColor: Menu background color.
    ///   - menuTextColor: Menu text color.
    ///   - homeIcon: The icon for the navigation bar button that restores the interface to its default state.
    ///   - homeTitle: Navigation title for default state.
    ///   - searchTitle: Navigation title for search state.
    ///   - isShowPageMenu: Determines the visibility of the page menu.
    ///   - isShowTagMenu: Determines the visibility of the tag menu.
    ///   - isShowCategoryMenu: Determines the visibility of the category menu.
    ///   - pageMenuTitle: Determines the title of the page menu.
    ///   - tagMenuTitle: Determines the title of the tag menu.
    ///   - categoryMenuTitle: Determines the title of the category menu.
    ///   - isParseHTMLWithYouTubePreviews: If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with an active link.
    ///   - isExcludeWebHeaderAndFooter: Remove web page's header and footer.
    ///   - isMenuExpanded: To expand menu items by default.
    public static func configure(
        host: String,
        httpScheme: HTTPScheme = .https,
        postsPerPage: Int = 50,
        tagPathComponent: String = "tag",
        categoryPathComponent: String = "category",
        isShowContentInWebView: Bool = false,
        isShowFeaturedImage: Bool = true,
        postListFont: Font = .title2,
        postBodyFont: UIFont = .systemFont(ofSize: 17),
        postTitleFont: Font = .largeTitle,
        backgroundColor: Color = Color(uiColor: .systemBackground),
        interfaceColor: Color = .primary,
        textColor: Color = .primary,
        menuBackgroundColor: Color = .primary,
        menuTextColor: Color = Color(uiColor: .systemBackground),
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
    ) {
        
        Preferences.shared.configure(with:
                .init(
                    host: host,
                    httpScheme: httpScheme,
                    postsPerPage: postsPerPage,
                    tagPathComponent: tagPathComponent,
                    categoryPathComponent: categoryPathComponent,
                    postListFont: postListFont,
                    postBodyFont: postBodyFont,
                    postTitleFont: postTitleFont,
                    isShowFeaturedImage: isShowFeaturedImage,
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
        )
    }
    
}
