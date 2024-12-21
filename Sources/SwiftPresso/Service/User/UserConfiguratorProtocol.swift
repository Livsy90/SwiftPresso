import SkavokNetworking

protocol UserConfiguratorProtocol: Sendable {
    func registerRequest(
        username: String,
        email: String,
        password: String
    ) -> Request<UserResponse>
    
    func editRequest(
        id: Int,
        email: String?,
        password: String?,
        description: String?
    ) -> Request<UserResponse>
    
    func loginRequest(
        username: String,
        password: String
    ) -> Request<LoginResponse>
    
    func userInfo() -> Request<UserInfo>
}
