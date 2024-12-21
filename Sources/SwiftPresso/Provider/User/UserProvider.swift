struct UserProvider: UserProviderProtocol {
    
    private let service: any UserServiceProtocol
    
    init(service: some UserServiceProtocol) {
        self.service = service
    }
    
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> UserResponse {
        try await service.register(
            username: username,
            email: email,
            password: password
        )
    }
    
}
