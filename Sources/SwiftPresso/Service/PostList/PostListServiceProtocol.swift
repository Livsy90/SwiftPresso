import SkavokNetworking

public protocol PostListServiceProtocol {
    func requestPosts(pageNumber: Int) async throws -> [WPPost]
}
