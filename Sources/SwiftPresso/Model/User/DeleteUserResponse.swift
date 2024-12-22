public struct DeleteUserResponse: Codable, Sendable {
    public let isDeleted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case isDeleted = "deleted"
    }
}
