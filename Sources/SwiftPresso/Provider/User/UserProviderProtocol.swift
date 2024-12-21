public protocol UserProviderProtocol: Sendable {
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> UserResponse
}
