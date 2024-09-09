import SkavokNetworking

protocol PostListServiceProtocol {
    func requestPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [WPPost]
}
