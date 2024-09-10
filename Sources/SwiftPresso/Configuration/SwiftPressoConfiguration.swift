import SwiftUI

public struct SwiftPressoConfiguration {
    public let host: String
    public let postsPerPage: Int
    public let httpScheme: HTTPScheme
    public let isExcludeWebHeaderAndFooter: Bool
    public let backgroundColor: Color
    public let interfaceColor: Color
    public let textColor: Color
    public let isShowPageMenu: Bool
    public let isShowTagMenu: Bool
    public let isShowCategoryMenu: Bool
    public let homeIcon: Image
    public let homeTitle: String?
    public let searchTitle: String?
    public let pageMenuTitle: String
    public let tagMenuTitle: String
    public let categoryMenuTitle: String
    public let menuBackgroundColor: Color
    public let menuTextColor: Color
    
    public init(
        host: String,
        backgroundColor: Color = Color(uiColor: .systemBackground),
        interfaceColor: Color = .primary,
        textColor: Color = .primary,
        homeIcon: Image = Image(systemName: "house"),
        homeTitle: String? = nil,
        searchTitle: String? = nil,
        isShowPageMenu: Bool = true,
        isShowTagMenu: Bool = true,
        isShowCategoryMenu: Bool = true,
        pageMenuTitle: String = "Pages",
        tagMenuTitle: String = "Tags",
        categoryMenuTitle: String = "Category",
        menuBackgroundColor: Color = .primary,
        menuTextColor: Color = Color(uiColor: .systemBackground),
        postsPerPage: Int = 50,
        httpScheme: HTTPScheme = .https,
        isExcludeWebHeaderAndFooter: Bool = true
    ) {
        self.host = host
        self.backgroundColor = backgroundColor
        self.interfaceColor = interfaceColor
        self.textColor = textColor
        self.isShowPageMenu = isShowPageMenu
        self.isShowTagMenu = isShowTagMenu
        self.isShowCategoryMenu = isShowCategoryMenu
        self.pageMenuTitle = pageMenuTitle
        self.tagMenuTitle = tagMenuTitle
        self.categoryMenuTitle = categoryMenuTitle
        self.menuBackgroundColor = menuBackgroundColor
        self.menuTextColor = menuTextColor
        self.postsPerPage = postsPerPage
        self.httpScheme = httpScheme
        self.isExcludeWebHeaderAndFooter = isExcludeWebHeaderAndFooter
        self.homeIcon = homeIcon
        self.homeTitle = homeTitle
        self.searchTitle = searchTitle
    }
}

extension SwiftPressoConfiguration: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .init(host: value)
    }
}
