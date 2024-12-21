import Foundation

// MARK: - UserResponse

public struct UserResponse: Codable, Sendable {
    public let id: Int
    public let username, name, firstName, lastName: String
    public let email, url, description: String

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case email, url, description
    }
}
