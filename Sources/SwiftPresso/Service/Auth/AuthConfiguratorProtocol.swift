import SkavokNetworking

protocol AuthConfiguratorProtocol: Sendable {
    func loginRequest(
        username: String,
        password: String
    ) -> Request<LoginResponse>
    
    func userInfo(token: String) -> Request<UserInfo>
}
