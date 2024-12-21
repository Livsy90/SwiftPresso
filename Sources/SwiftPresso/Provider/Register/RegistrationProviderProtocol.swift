public protocol RegistrationProviderProtocol: Sendable {
    func register(
        username: String,
        email: String,
        password: String,
        appName: String,
        appPassword: String
    ) async throws -> RegisterModel
}
