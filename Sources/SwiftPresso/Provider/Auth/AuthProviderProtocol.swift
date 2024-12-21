public protocol AuthProviderProtocol: Sendable {
    func login(
        username: String,
        password: String
    ) async throws -> LoginResponse
    
    func userInfo(token: String) async throws -> UserInfo
}
