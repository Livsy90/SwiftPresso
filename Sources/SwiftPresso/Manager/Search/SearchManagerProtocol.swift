public protocol SearchManagerProtocol {
    func getPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String
    ) async throws -> [RefinedPost]
}
