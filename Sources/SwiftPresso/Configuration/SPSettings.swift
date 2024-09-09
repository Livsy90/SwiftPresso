import Foundation

public final class SPSettings {
    
    public struct Configuration {
        let host: String
        let postsPerPage: Int
        let httpScheme: HTTPScheme
        let httpAdditionalHeaders: [AnyHashable: Any]?
        let isExcludeWebHeaderAndFooter: Bool
        
        public init(
            host: String,
            postsPerPage: Int = 50,
            httpScheme: HTTPScheme = .https,
            httpAdditionalHeaders: [AnyHashable : Any]? = nil,
            isExcludeWebHeaderAndFooter: Bool = true
        ) {
            self.host = host
            self.postsPerPage = postsPerPage
            self.httpScheme = httpScheme
            self.httpAdditionalHeaders = httpAdditionalHeaders
            self.isExcludeWebHeaderAndFooter = isExcludeWebHeaderAndFooter
        }
    }
    
    public static let shared: SPSettings = .init()
    
    public private(set) var host: String = ""
    public private(set) var postsPerPage: Int = 50
    public private(set) var httpScheme: HTTPScheme = .https
    public private(set) var httpAdditionalHeaders: [AnyHashable: Any]?
    public private(set) var isExcludeWebHeaderAndFooter: Bool = true
    
    private init() {}
    
    public func configure(with configuration: Configuration) {
        self.host = configuration.host
        self.postsPerPage = configuration.postsPerPage
        self.httpScheme = configuration.httpScheme
        self.httpAdditionalHeaders = configuration.httpAdditionalHeaders
        self.isExcludeWebHeaderAndFooter = configuration.isExcludeWebHeaderAndFooter
    }
    
}
