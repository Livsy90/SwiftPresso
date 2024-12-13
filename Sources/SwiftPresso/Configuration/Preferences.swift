import SwiftUI
import Foundation

public final class Preferences: @unchecked Sendable {
    
    static let shared: Preferences = .init()
    
    var configuration: Configuration {
        get {
            queue.sync {
                _configuration
            }
        }
        set {
            queue.async(flags: .barrier) {
                self._configuration = newValue
            }
        }
    }
    
    private let queue = DispatchQueue(
        label: "com.swiftpresso.queue",
        qos: .default,
        attributes: .concurrent
    )
    private var _configuration: Configuration = .initial
    
    private init() {}
    
}

extension Preferences {
    
    struct Configuration {
        
        let host: String
        let postsPerPage: Int
        let httpScheme: HTTPScheme
        let tagPathComponent: String
        let categoryPathComponent: String
        
        let postListFont: Font
        let postBodyFont: UIFont
        let postTitleFont: Font
        let isShowFeaturedImage: Bool
        let isShowContentInWebView: Bool
        let isExcludeWebHeaderAndFooter: Bool
        let isMenuExpanded: Bool
        let backgroundColor: Color
        let interfaceColor: Color
        let textColor: Color
        let isShowPageMenu: Bool
        let isShowTagMenu: Bool
        let isShowCategoryMenu: Bool
        let homeIcon: Image
        let homeTitle: String
        let searchTitle: String
        let pageMenuTitle: String
        let tagMenuTitle: String
        let categoryMenuTitle: String
        let menuBackgroundColor: Color
        let menuTextColor: Color
        let isParseHTMLWithYouTubePreviews: Bool
        
        init(
            host: String,
            httpScheme: HTTPScheme,
            postsPerPage: Int,
            tagPathComponent: String,
            categoryPathComponent: String,
            postListFont: Font,
            postBodyFont: UIFont,
            postTitleFont: Font,
            isShowFeaturedImage: Bool,
            isShowContentInWebView: Bool,
            menuBackgroundColor: Color,
            menuTextColor: Color,
            backgroundColor: Color,
            interfaceColor: Color,
            textColor: Color,
            homeIcon: Image,
            homeTitle: String,
            searchTitle: String,
            isShowPageMenu: Bool,
            isShowTagMenu: Bool,
            isShowCategoryMenu: Bool,
            pageMenuTitle: String,
            tagMenuTitle: String,
            categoryMenuTitle: String,
            isParseHTMLWithYouTubePreviews: Bool,
            isExcludeWebHeaderAndFooter: Bool,
            isMenuExpanded: Bool
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
            self.isMenuExpanded = isMenuExpanded
            self.isShowContentInWebView = isShowContentInWebView
            self.isParseHTMLWithYouTubePreviews = isParseHTMLWithYouTubePreviews
            self.tagPathComponent = tagPathComponent
            self.categoryPathComponent = categoryPathComponent
            self.postListFont = postListFont
            self.postBodyFont = postBodyFont
            self.postTitleFont = postTitleFont
            self.isShowFeaturedImage = isShowFeaturedImage
        }
    }
    
}

extension Preferences.Configuration {
    
    static let initial: Preferences.Configuration = .init(
        host: "",
        httpScheme: .https,
        postsPerPage: .zero,
        tagPathComponent: "",
        categoryPathComponent: "",
        postListFont: .title3,
        postBodyFont: .systemFont(ofSize: 17),
        postTitleFont: .largeTitle,
        isShowFeaturedImage: true,
        isShowContentInWebView: true,
        menuBackgroundColor: .primary,
        menuTextColor: Color(uiColor: .systemBackground),
        backgroundColor: Color(uiColor: .systemBackground),
        interfaceColor: .primary,
        textColor: .primary,
        homeIcon: Image(systemName: "house"),
        homeTitle: "Home",
        searchTitle: "Search",
        isShowPageMenu: true,
        isShowTagMenu: true,
        isShowCategoryMenu: true,
        pageMenuTitle: "Pages",
        tagMenuTitle: "Tags",
        categoryMenuTitle: "Categories",
        isParseHTMLWithYouTubePreviews: true,
        isExcludeWebHeaderAndFooter: true,
        isMenuExpanded: true
    )
    
}
