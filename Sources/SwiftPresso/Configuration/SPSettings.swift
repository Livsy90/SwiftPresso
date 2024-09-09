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
        public let isShowPageMenu: Bool
        public let isShowTagMenu: Bool
        public let isShowCategoryMenu: Bool
        
        public init(
            host: String,
            backgroundColor: Color = .white,
            accentColor: Color = .blue,
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
            self.isShowPageMenu = isShowPageMenu
            self.isShowTagMenu = isShowTagMenu
            self.isShowCategoryMenu = isShowCategoryMenu
            self.postsPerPage = postsPerPage
            self.httpScheme = httpScheme
            self.httpAdditionalHeaders = httpAdditionalHeaders
            self.isExcludeWebHeaderAndFooter = isExcludeWebHeaderAndFooter
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
