struct LoginRequest: Encodable, Sendable {
    let username: String
    let password: String
}
