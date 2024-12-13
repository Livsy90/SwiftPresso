import SkavokNetworking

protocol PageListServiceProtocol: Sendable {
    func requestPages() async throws -> [WPPost]
}
