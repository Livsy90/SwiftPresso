import SkavokNetworking

public protocol SearchServiceProtocol {
    func requestPosts(
        pageNumber: Int,
        searchTerms: String,
        perPage: Int
    ) async throws -> [WPPost]
}
