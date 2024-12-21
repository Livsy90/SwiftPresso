import Foundation

// MARK: - UserResponse

public struct UserResponse: Codable, Sendable {
    public let id: Int
    public let username, name, firstName, lastName: String
    public let email, url, description: String
    public let link: String
    public let locale, nickname, slug: String
    public let roles: [String]
    public let registeredDate: Date
    public let capabilities: Capabilities
    public let extraCapabilities: ExtraCapabilities
    public let avatarUrls: [String: String]

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case email, url, description, link, locale, nickname, slug, roles
        case registeredDate = "registered_date"
        case capabilities
        case extraCapabilities = "extra_capabilities"
        case avatarUrls = "avatar_urls"
    }
}

// MARK: - Capabilities

public struct Capabilities: Codable, Sendable {
    public let read, level0, subscriber: Bool

    enum CodingKeys: String, CodingKey {
        case read
        case level0 = "level_0"
        case subscriber
    }
}

// MARK: - ExtraCapabilities

public struct ExtraCapabilities: Codable, Sendable {
    public let subscriber: Bool
}
