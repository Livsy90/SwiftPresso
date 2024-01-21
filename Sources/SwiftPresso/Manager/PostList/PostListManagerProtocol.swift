public protocol PostListManagerProtocol {
    func getPosts(pageNumber: Int) async throws -> [RefinedPost]
}
