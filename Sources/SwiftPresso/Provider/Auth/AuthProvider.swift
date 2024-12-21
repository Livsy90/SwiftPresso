struct AuthProvider: AuthProviderProtocol {
    
    private let service: any AuthServiceProtocol
    
    init(service: some AuthServiceProtocol) {
        self.service = service
    }
    
    func login(
        username: String,
        password: String
    ) async throws -> LoginResponse {
        try await service.login(
            username: username,
            password: password
        )
    }
    
    func userInfo(token: String) async throws -> UserInfo {
        try await service.userInfo(token: token)
    }
    
}
