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
    
    func edit(
        id: Int,
        email: String?,
        password: String?,
        description: String?
    ) async throws -> UserResponse {
        
        let request: Request<UserResponse> = configurator.editRequest(
            id: id,
            email: email,
            password: password,
            description: description
        )
        return try await networkClient.send(request).value
    }
    
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
    
    func userInfo(username: String) async throws -> UserInfo {
        let request: Request<UserInfo> = configurator.userInfo(username: username)
        return try await networkClient.send(request).value
    }
    
}
