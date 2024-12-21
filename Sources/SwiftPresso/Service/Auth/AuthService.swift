import SkavokNetworking

struct AuthService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any AuthConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some AuthConfiguratorProtocol
    ) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension AuthService: AuthServiceProtocol {
    
    func login(
        username: String,
        password: String
    ) async throws -> LoginResponse {
        
        let request: Request<LoginResponse> = configurator.loginRequest(
            username: username,
            password: password
        )
        return try await networkClient.send(request).value
    }
    
    func userInfo(token: String) async throws -> UserInfo {
        let request: Request<UserInfo> = configurator.userInfo(token: token)
        return try await networkClient.send(request).value
    }
    
}
