import SwiftUI
import Foundation
import Synchronization

@dynamicMemberLookup
public final class Preferences: Sendable {
    
    static let shared: Preferences = .init()
    
    static subscript<T>(dynamicMember keyPath: KeyPath<Configuration, T>) -> T {
        shared.configuration[keyPath: keyPath]
    }
    
    private let _configuration: Mutex<Configuration> = .init(.initial)
    
    var configuration: Configuration {
        get {
            _configuration.withLock { value in
                value
            }
        }
        set {
            _configuration.withLock { value in
                value = newValue
            }
        }
    }

    private init() {}
    
    func configure(with configuration: Configuration) {
        self.configuration = configuration
    }
    
    func configureContentPassword(_ password: String) {
        configuration.contentPassword = password
    }
    
    func configurePasswordIcon(_ icon: PasswordProtectedIcon) {
        configuration.passwordProtectedIcon = icon
    }
    
}

extension Preferences {
    
    struct Configuration {
        
        let host: String
        let postsPerPage: Int
        let httpScheme: HTTPScheme
        let tagPathComponent: String
        let categoryPathComponent: String
        let appCredentials: AppCredentials
        let postListFont: Font
        let postBodyFont: UIFont
        let postTitleFont: Font
        let isShowFeaturedImage: Bool
        let isShowContentInWebView: Bool
        let isExcludeWebHeaderAndFooter: Bool
        let isMenuExpanded: Bool
        let backgroundColor: Color
        let accentColor: Color
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
        let menuTextColor: Color
        let isParseHTMLWithYouTubePreviews: Bool
        let keychainKey: String
        let appName: String
        let email: String
        var contentPassword: String
        var passwordProtectedIcon: PasswordProtectedIcon
        
        init(
            host: String,
            httpScheme: HTTPScheme,
            postsPerPage: Int,
            tagPathComponent: String,
            categoryPathComponent: String,
            appCredentials: AppCredentials,
            postListFont: Font,
            postBodyFont: UIFont,
            postTitleFont: Font,
            isShowFeaturedImage: Bool,
            isShowContentInWebView: Bool,
            menuTextColor: Color,
            backgroundColor: Color,
            accentColor: Color,
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
            isMenuExpanded: Bool,
            keychainKey: String,
            contentPassword: String,
            passwordProtectedIcon: PasswordProtectedIcon,
            appName: String,
            email: String
        ) {
            self.host = host
            self.backgroundColor = backgroundColor
            self.accentColor = accentColor
            self.textColor = textColor
            self.isShowPageMenu = isShowPageMenu
            self.isShowTagMenu = isShowTagMenu
            self.isShowCategoryMenu = isShowCategoryMenu
            self.appCredentials = appCredentials
            self.pageMenuTitle = pageMenuTitle
            self.tagMenuTitle = tagMenuTitle
            self.categoryMenuTitle = categoryMenuTitle
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
            self.keychainKey = keychainKey
            self.contentPassword = contentPassword
            self.passwordProtectedIcon = passwordProtectedIcon
            self.appName = appName
            self.email = email
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
        appCredentials: .init(username: "", password: ""),
        postListFont: .title3,
        postBodyFont: .systemFont(ofSize: 17),
        postTitleFont: .largeTitle,
        isShowFeaturedImage: true,
        isShowContentInWebView: true,
        menuTextColor: .primary,
        backgroundColor: Color(uiColor: .systemBackground),
        accentColor: .primary,
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
        isMenuExpanded: true,
        keychainKey: "SwiftPresso",
        contentPassword: "",
        passwordProtectedIcon: .lock,
        appName: "",
        email: ""
    )
    
}

extension Preferences {
    
    public struct AppCredentials: Sendable {
        let username: String
        let password: String
        
        public init(username: String, password: String) {
            self.username = username
            self.password = password
        }
    }
    
}

extension Preferences {
    
    public enum PasswordProtectedIcon: String, Sendable {
        case lock = "lock.fill"
        case openLock = "lock.open.fill"
        case star = "star"
        
        var image: Image {
            Image(systemName: rawValue)
        }
    }
    
}
