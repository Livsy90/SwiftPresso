struct WPPost: Codable {
    struct WPEmbeddedPost: Codable {
        let author: [WPAuthor]?
        let wpFeaturedMedia: [WPMedia]?
        let wpTerm: [[WPEmbeddedTerm]]?
        
        private enum CodingKeys: String, CodingKey {
            case author
            case wpFeaturedMedia = "wp:featuredmedia"
            case wpTerm = "wp:term"
        }
    }
    
    struct WPAuthor: Codable {
        let id: Int
        let name: String?
        let url: String?
        let description: String?
        let link: String?
        let slug: String?
        let avatarUrls: [Int:String]?
        
        private enum CodingKeys: String, CodingKey {
            case id, name, url, description, link, slug
            case avatarUrls = "avatar_urls"
        }
    }
    
    struct WPProtectedText: Codable {
        let rendered: String
        let protected: Bool?
    }
    
    struct WPEmbeddedTerm: Codable {
        let id: Int?
        let link: String?
        let name: String?
        let slug: String?
        let taxonomy: String?
        let links: WPLinks?
        
        private enum CodingKeys: String, CodingKey {
            case id, link, name, slug, taxonomy
            case links = "_links"
        }
    }
    
    let id: Int
    let date: String
    let dateGMT: String
    let guid: WPText
    let modified: String
    let modifiedGMT: String
    let slug: String
    let status: String
    let type: String
    let link: String
    let title: WPText
    let content: WPProtectedText
    let excerpt: WPProtectedText?
    let author: Int
    let featuredMedia: Int?
    let commentStatus: String?
    let pingStatus: String?
    let sticky: Bool?
    let format: String?
    let categories: [Int]?
    let tags: [Int]?
    let links: WPLinks?
    var embedded: WPEmbeddedPost?
    
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

struct WPText: Codable {
    let rendered: String
}

struct WPLinks: Codable {
    struct WPLink: Codable {
        let href: String
    }
    
    struct WPEmbeddableLink: Codable {
        let href: String?
        let embeddable: Bool?
    }
    
    struct WPTerm: Codable {
        let taxonomy: String?
        let embeddable: Bool?
        let href: String?
    }
    
    let `self`: [WPLink]?
    let collection: [WPLink]?
    let about: [WPLink]?
    let author: [WPEmbeddableLink]?
    let replies: [WPEmbeddableLink]?
    let versionHistory: [WPLink]?
    let wpFeaturedmedia: [WPEmbeddableLink]?
    let wpAttachment: [WPLink]?
    let wpTerm: [WPTerm]?
    
    private enum CodingKeys: String, CodingKey {
        case collection, about, author, replies, `self`
        case versionHistory = "version-history"
        case wpFeaturedmedia = "wp:featuredmedia"
        case wpAttachment = "wp:attachment"
        case wpTerm = "wp:term"
    }
}
