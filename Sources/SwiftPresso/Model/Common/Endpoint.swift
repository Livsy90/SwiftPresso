enum Endpoint: String {
    case posts
    case categories
    case tags
    case pages
    case register = "users/register"
    
    static func path(for endpoint: Endpoint) -> String {
        "/wp-json/wp/v2/\(endpoint.rawValue)"
    }
}
