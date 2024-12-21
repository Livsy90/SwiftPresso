enum Endpoint {
    case posts
    case categories
    case tags
    case pages
    case users
    case userInfo
    case userEdit(Int)
    case login
    
    static func path(for endpoint: Self) -> String {
        "/wp-json/\(_path(endpoint))\(endpoint.apiPath)"
    }
    
    private static func _path(_ endpoint: Self) -> String {
        switch endpoint {
        case .login:
            "jwt-auth/v1/"
        default:
            "wp/v2/"
        }
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
        case .userInfo:
            "users/me"
        case .userEdit(let id):
            "users/\(id)"
        case .login:
            "token"
        }
    }
}
