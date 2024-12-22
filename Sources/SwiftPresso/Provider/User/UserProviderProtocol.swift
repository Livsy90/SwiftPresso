public protocol UserProviderProtocol: Sendable {
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> UserResponse
    
    func edit(
        id: Int,
        email: String?,
        password: String?,
        description: String?
    ) async throws -> UserResponse
    
    func delete(id: Int) async throws -> UserResponse
}
