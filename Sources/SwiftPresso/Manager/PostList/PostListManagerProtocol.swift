public protocol PostListManagerProtocol {
    func getPosts(
        pageNumber: Int,
        perPage: Int,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [RefinedPost]
}
