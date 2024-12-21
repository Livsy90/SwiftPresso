public struct LoginResponse: Codable, Sendable {
    public var token: String
    public var userEmail: String
    public var userNicename: String
    public var userDisplayName: String
    
    private enum CodingKeys: String, CodingKey {
        case token
        case userEmail = "user_email"
        case userNicename = "user_nicename"
        case userDisplayName = "user_display_name"
    }
}
