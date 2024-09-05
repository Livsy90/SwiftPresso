enum Endpoint: String {
    case posts
    case categories
    
    static func path(for endpoint: Endpoint) -> String {
        "/wp-json/wp/v2/\(endpoint.rawValue)"
    }
}
