import SkavokNetworking

protocol RegistrationConfiguratorProtocol: Sendable {
    func registerRequest(
        username: String,
        email: String,
        password: String
    ) -> Request<RegisterModel>
}
