public protocol PostListProviderProtocol {
    func getRefinedPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [PostModel]
    
    func getRawPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [WPPost]
}
