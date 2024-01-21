public struct WPMedia: Codable {
    public struct WPMediaDetails: Codable {
        public let width: Double?
        public let height: Double?
        public let file: String?
        public let sizes: WPMediaSizes?
    }

    public struct WPMediaSizes: Codable {
        public let thumbnail: WPMediaSize?
        public let medium: WPMediaSize?
        public let mediumLarge: WPMediaSize?
        public let large: WPMediaSize?
        public let full: WPMediaSize?
        
        private enum CodingKeys: String, CodingKey {
            case thumbnail, medium, large, full
            case mediumLarge = "medium_large"
        }
    }

    public struct WPMediaSize: Codable {
        public let file: String?
        public let width: Double?
        public let height: Double?
        public let mimeType: String?
        public let sourceUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case file, width, height
            case mimeType = "mime_type"
            case sourceUrl = "source_url"
        }
    }
    
    public let id: Int?
    public let date: String?
    public let slug: String?
    public let type: String?
    public let link: String?
    public let title: WPText?
    public let author: Int?
    public let caption: WPText?
    public let altText: String?
    public let mediaType: String?
    public let mimeType: String?
    public let mediaDetails: WPMediaDetails?
    public let sourceUrl: String?
    public let links: WPLinks?
    
    private enum CodingKeys: String, CodingKey {
        case id, date, slug, type, link, title, author, caption
        case altText = "alt_text"
        case mediaType = "media_type"
        case mimeType = "mime_type"
        case mediaDetails = "media_details"
        case sourceUrl = "source_url"
        case links = "_links"
    }
}
