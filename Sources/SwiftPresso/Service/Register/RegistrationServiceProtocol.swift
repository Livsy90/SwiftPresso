import SkavokNetworking

protocol RegistrationServiceProtocol: Sendable {
    func register(
        username: String,
        email: String,
        password: String
    ) async throws -> RegisterModel
}
