import Foundation

// MARK: - UserResponse

public struct UserResponse: Codable, Sendable {
    public let id: Int
    public let username: String
    public let name: String?
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let url: String?
    public let description: String?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case email, url, description
    }
}
