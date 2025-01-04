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
    
    func updateToken() async throws {
        guard
            let username = SwiftPresso.UserData.login,
            let password = SwiftPresso.UserData.password
        else { return }
        let response = try await service.login(
            username: username,
            password: password
        )
        print(response)
    }
    
    func userInfo(token: String) async throws -> UserInfo {
        try await service.userInfo(token: token)
    }
    
}
