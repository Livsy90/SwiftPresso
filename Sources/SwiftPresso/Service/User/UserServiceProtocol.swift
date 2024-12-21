import SkavokNetworking

protocol UserServiceProtocol: Sendable {
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
    
    func login(
        username: String,
        password: String
    ) async throws -> LoginResponse
    
    func userInfo() async throws -> UserInfo
}
