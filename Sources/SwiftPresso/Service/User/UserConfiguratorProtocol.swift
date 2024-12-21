import SkavokNetworking

protocol UserConfiguratorProtocol: Sendable {
    func registerRequest(
        username: String,
        email: String,
        password: String
    ) -> Request<UserResponse>
}
