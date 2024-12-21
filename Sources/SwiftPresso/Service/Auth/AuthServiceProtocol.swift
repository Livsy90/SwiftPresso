import SkavokNetworking

protocol AuthServiceProtocol: Sendable {
    func login(
        username: String,
        password: String
    ) async throws -> LoginResponse
    
    func userInfo(token: String) async throws -> UserInfo
}
