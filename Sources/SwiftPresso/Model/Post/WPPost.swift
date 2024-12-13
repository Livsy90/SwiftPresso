public struct WPPost: Codable, Sendable {
    public struct WPEmbeddedPost: Codable, Sendable {
        public let author: [WPAuthor]?
        public let wpFeaturedMedia: [WPMedia]?
        public let wpTerm: [[WPEmbeddedTerm]]?
        
        private enum CodingKeys: String, CodingKey {
            case author
            case wpFeaturedMedia = "wp:featuredmedia"
            case wpTerm = "wp:term"
        }
    }
    
    public struct WPAuthor: Codable, Sendable {
        public let id: Int
        public let name: String?
        public let url: String?
        public let description: String?
        public let link: String?
        public let slug: String?
        public let avatarUrls: [Int:String]?
        
        private enum CodingKeys: String, CodingKey {
            case id, name, url, description, link, slug
            case avatarUrls = "avatar_urls"
        }
    }
    
    public struct WPProtectedText: Codable, Sendable {
        public let rendered: String
        public let protected: Bool?
    }
    
    public struct WPEmbeddedTerm: Codable, Sendable {
        public let id: Int?
        public let link: String?
        public let name: String?
        public let slug: String?
        public let taxonomy: String?
        public let links: WPLinks?
        
        private enum CodingKeys: String, CodingKey {
            case id, link, name, slug, taxonomy
            case links = "_links"
        }
    }
    
    public let id: Int
    public let date: String
    public let dateGMT: String
    public let guid: WPText
    public let modified: String
    public let modifiedGMT: String
    public let slug: String
    public let status: String
    public let type: String
    public let link: String
    public let title: WPText
    public let content: WPProtectedText
    public let excerpt: WPProtectedText?
    public let author: Int
    public let featuredMedia: Int?
    public let commentStatus: String?
    public let pingStatus: String?
    public let sticky: Bool?
    public let format: String?
    public let categories: [Int]?
    public let tags: [Int]?
    public let links: WPLinks?
    public var embedded: WPEmbeddedPost?
    
    private enum CodingKeys: String, CodingKey {
        case id, date, guid, modified, slug, status, type, link, title, content, excerpt, author, sticky, format, categories, tags
        case dateGMT = "date_gmt"
        case modifiedGMT = "modified_gmt"
        case featuredMedia = "featured_media"
        case commentStatus = "comment_status"
        case pingStatus = "ping_status"
        case links = "_links"
        case embedded = "_embedded"
    }
}

public struct WPText: Codable, Sendable {
    public let rendered: String
}

public struct WPLinks: Codable, Sendable {
    public struct WPLink: Codable, Sendable {
        public let href: String
    }
    
    public struct WPEmbeddableLink: Codable, Sendable {
        public let href: String?
        public let embeddable: Bool?
    }
    
    public struct WPTerm: Codable, Sendable {
        public let taxonomy: String?
        public let embeddable: Bool?
        public let href: String?
    }
    
    public let `self`: [WPLink]?
    public let collection: [WPLink]?
    public let about: [WPLink]?
    public let author: [WPEmbeddableLink]?
    public let replies: [WPEmbeddableLink]?
    public let versionHistory: [WPLink]?
    public let wpFeaturedmedia: [WPEmbeddableLink]?
    public let wpAttachment: [WPLink]?
    public let wpTerm: [WPTerm]?
    
    private enum CodingKeys: String, CodingKey {
        case collection, about, author, replies, `self`
        case versionHistory = "version-history"
        case wpFeaturedmedia = "wp:featuredmedia"
        case wpAttachment = "wp:attachment"
        case wpTerm = "wp:term"
    }
}
