struct WPMedia: Codable {
    struct WPMediaDetails: Codable {
        let width: Double?
        let height: Double?
        let file: String?
        let sizes: WPMediaSizes?
    }
    
    struct WPMediaSizes: Codable {
        let thumbnail: WPMediaSize?
        let medium: WPMediaSize?
        let mediumLarge: WPMediaSize?
        let large: WPMediaSize?
        let full: WPMediaSize?
        
        private enum CodingKeys: String, CodingKey {
            case thumbnail, medium, large, full
            case mediumLarge = "medium_large"
        }
    }
    
    struct WPMediaSize: Codable {
        let file: String?
        let width: Double?
        let height: Double?
        let mimeType: String?
        let sourceUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case file, width, height
            case mimeType = "mime_type"
            case sourceUrl = "source_url"
        }
    }
    
    let id: Int?
    let date: String?
    let slug: String?
    let type: String?
    let link: String?
    let title: WPText?
    let author: Int?
    let caption: WPText?
    let altText: String?
    let mediaType: String?
    let mimeType: String?
    let mediaDetails: WPMediaDetails?
    let sourceUrl: String?
    let links: WPLinks?
    
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
