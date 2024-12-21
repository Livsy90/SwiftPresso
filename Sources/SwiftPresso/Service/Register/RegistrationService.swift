import SkavokNetworking

struct RegistrationService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any RegistrationConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some RegistrationConfiguratorProtocol
    ) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension RegistrationService: RegistrationServiceProtocol {
   
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> RegisterModel {

        let request: Request<RegisterModel> = configurator.registerRequest(
            username: username,
            email: email,
            password: password
        )
        return try await networkClient.send(request).value
    }
    
}
