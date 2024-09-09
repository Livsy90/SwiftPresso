import SwiftUI
import Foundation

public final class SPSettings {
    
    public struct Configuration {
        public let host: String
        public let postsPerPage: Int
        public let httpScheme: HTTPScheme
        public let httpAdditionalHeaders: [AnyHashable: Any]?
        public let isExcludeWebHeaderAndFooter: Bool
        public let backgroundColor: Color
        public let accentColor: Color
        public let textColor: Color
        public let isShowPageMenu: Bool
        public let isShowTagMenu: Bool
        public let isShowCategoryMenu: Bool
        public let tagIcon: Image
        public let pageIcon: Image
        public let categoryIcon: Image
        public let homeIcon: Image
        
        public init(
            host: String,
            backgroundColor: Color = .white,
            accentColor: Color = .blue,
            textColor: Color = .primary,
            tagIcon: Image = Image(systemName: "tag"),
            pageIcon: Image = Image(systemName: "book"),
            categoryIcon: Image = Image(systemName: "list.bullet.below.rectangle"),
            homeIcon: Image = Image(systemName: "house"),
            isShowPageMenu: Bool = true,
            isShowTagMenu: Bool = true,
            isShowCategoryMenu: Bool = true,
            postsPerPage: Int = 50,
            httpScheme: HTTPScheme = .https,
            httpAdditionalHeaders: [AnyHashable : Any]? = nil,
            isExcludeWebHeaderAndFooter: Bool = true
        ) {
            self.host = host
            self.backgroundColor = backgroundColor
            self.accentColor = accentColor
            self.textColor = textColor
            self.isShowPageMenu = isShowPageMenu
            self.isShowTagMenu = isShowTagMenu
            self.isShowCategoryMenu = isShowCategoryMenu
            self.postsPerPage = postsPerPage
            self.httpScheme = httpScheme
            self.httpAdditionalHeaders = httpAdditionalHeaders
            self.isExcludeWebHeaderAndFooter = isExcludeWebHeaderAndFooter
            self.homeIcon = homeIcon
            self.tagIcon = tagIcon
            self.pageIcon = pageIcon
            self.categoryIcon = categoryIcon
        }
    }
    
    public static let shared: SPSettings = .init()
    
    public var configuration: Configuration {
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
        label: "com.spsettings.queue",
        qos: .default,
        attributes: .concurrent
    )
    private var _configuration = Configuration.init(
        host: "",
        backgroundColor: .white,
        accentColor: .blue
    )
    
    private init() {}
    
}
