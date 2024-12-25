public protocol PostProviderProtocol: Sendable {
    func getPost(id: Int, password: String?) async throws -> PostModel
    func getRawPost(id: Int, password: String?) async throws -> WPPost
}
