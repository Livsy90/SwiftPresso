public protocol PostProviderProtocol {
    func getRefinedPost(id: Int) async throws -> PostModel
    func getRawPost(id: Int) async throws -> WPPost
}
