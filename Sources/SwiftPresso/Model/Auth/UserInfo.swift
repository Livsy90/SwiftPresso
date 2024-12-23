public struct UserInfo: Codable, Sendable {
    public let id: Int
    public let name: String
    public let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
}
