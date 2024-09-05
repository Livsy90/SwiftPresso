import SkavokNetworking

public protocol PageListServiceProtocol {
    func requestPages() async throws -> [WPPost]
}
