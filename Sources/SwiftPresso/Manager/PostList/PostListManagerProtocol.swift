public protocol PostListManagerProtocol {
    func getPosts(pageNumber: Int, perPage: Int, categories: Int?) async throws -> [RefinedPost]
}
