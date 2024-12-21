import SkavokNetworking

protocol UserServiceProtocol: Sendable {
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> UserResponse
}
