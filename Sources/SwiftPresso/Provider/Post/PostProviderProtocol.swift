public protocol PostProviderProtocol {
    func getPost(id: Int) async throws -> PostModel
    func getRawPost(id: Int) async throws -> WPPost
}
