enum Endpoint {
    case posts
    case categories
    case tags
    case pages
    case users
    case userEdit(Int)
    
    static func path(for endpoint: Endpoint) -> String {
        "/wp-json/wp/v2/\(endpoint.apiPath)"
    }
}

extension Endpoint {
    var apiPath: String {
        switch self {
        case .posts:
            "posts"
        case .categories:
            "categories"
        case .tags:
            "tags"
        case .pages:
            "pages"
        case .users:
            "users"
        case .userEdit(let id):
            "users/\(id)"
        }
    }
}
