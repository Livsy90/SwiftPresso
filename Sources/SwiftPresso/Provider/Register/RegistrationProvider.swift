struct RegistrationProvider: RegistrationProviderProtocol {
    
    private let service: any RegistrationServiceProtocol
    
    init(service: some RegistrationServiceProtocol) {
        self.service = service
    }
    
    func register(
        username: String,
        email: String,
        password: String,
        appName: String,
        appPassword: String
    ) async throws -> RegisterModel {
        try await service.register(
            username: username,
            email: email,
            password: password,
            appName: appName,
            appPassword: appPassword
        )
    }
    
}
