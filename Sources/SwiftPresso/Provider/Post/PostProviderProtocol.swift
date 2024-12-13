public protocol PostProviderProtocol: Sendable {
    func getPost(id: Int) async throws -> PostModel
    func getRawPost(id: Int) async throws -> WPPost
}
