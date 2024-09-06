public protocol PostListManagerProtocol {
    func getPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [RefinedPost]
}
