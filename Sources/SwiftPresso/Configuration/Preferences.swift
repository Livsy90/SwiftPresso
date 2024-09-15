import SwiftUI
import Foundation

public final class Preferences {
    
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
    private var _configuration = Configuration.init(host: "")
    
    private init() {}
    
}

extension Preferences {
    
    public struct Configuration {
        
        let host: String
        let postsPerPage: Int
        let httpScheme: HTTPScheme
        let tagPathComponent: String
        let categoryPathComponent: String
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
        let homeTitle: String?
        let searchTitle: String?
        let pageMenuTitle: String
        let tagMenuTitle: String
        let categoryMenuTitle: String
        let menuBackgroundColor: Color
        let menuTextColor: Color
        let isParseHTMLWithYouTubePreviews: Bool
        
        public init(
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
            homeTitle: String? = nil,
            searchTitle: String? = nil,
            isShowPageMenu: Bool = true,
            isShowTagMenu: Bool = true,
            isShowCategoryMenu: Bool = true,
            pageMenuTitle: String = "Pages",
            tagMenuTitle: String = "Tags",
            categoryMenuTitle: String = "Category",
            isParseHTMLWithYouTubePreviews: Bool = true,
            isExcludeWebHeaderAndFooter: Bool = true,
            isMenuExpanded: Bool = true
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
        }
    }
    
}

extension Preferences.Configuration: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .init(host: value)
    }
}
