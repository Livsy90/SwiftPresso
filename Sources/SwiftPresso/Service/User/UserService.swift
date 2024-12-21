import SkavokNetworking

struct UserService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any UserConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some UserConfiguratorProtocol
    ) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension UserService: UserServiceProtocol {
   
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> UserResponse {

        let request: Request<UserResponse> = configurator.registerRequest(
            username: username,
            email: email,
            password: password
        )
        return try await networkClient.send(request).value
    }
    
}
