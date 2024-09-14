public protocol PostListProviderProtocol {
    func getPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?,
        includeIDs: [Int]?
    ) async throws -> [PostModel]
    
    func getRawPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?,
        includeIDs: [Int]?
    ) async throws -> [WPPost]
}
