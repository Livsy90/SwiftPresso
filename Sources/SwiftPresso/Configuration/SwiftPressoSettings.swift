import Foundation

public final class SwiftPressoSettings {
    
    public static let shared: SwiftPressoSettings = .init()
    
    public private(set) var host: String = ""
    public private(set) var postsPerPage: Int = 50
    public private(set) var httpScheme: HTTPScheme = .https
    public private(set) var httpAdditionalHeaders: [AnyHashable: Any]?
    public private(set) var isExcludeWebHeaderAndFooter: Bool = true
    
    private init() {}
    
    public func configure(
        host: String,
        postsPerPage: Int = 50,
        httpScheme: HTTPScheme = .https,
        httpAdditionalHeaders: [AnyHashable: Any]? = nil,
        isExcludeWebHeaderAndFooter: Bool = true
    ) {
        
        self.host = host
        self.postsPerPage = postsPerPage
        self.httpScheme = httpScheme
        self.httpAdditionalHeaders = httpAdditionalHeaders
        self.isExcludeWebHeaderAndFooter = isExcludeWebHeaderAndFooter
    }
    
}
