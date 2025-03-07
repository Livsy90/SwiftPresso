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
    
    func edit(
        id: Int,
        email: String?,
        password: String?,
        description: String?
    ) async throws -> UserResponse {
        try await service.edit(
            id: id,
            email: email,
            password: password,
            description: description
        )
    }
    
    func delete(id: Int) async throws -> DeleteUserResponse {
        try await service.delete(id: id)
    }
    
}
