import SkavokNetworking

public protocol PostListServiceProtocol {
    func requestPosts(
        pageNumber: Int,
        perPage: Int,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [WPPost]
}
