import SkavokNetworking

public protocol PostListServiceProtocol {
    func requestPosts(pageNumber: Int, perPage: Int, categories: [Int]?) async throws -> [WPPost]
}
