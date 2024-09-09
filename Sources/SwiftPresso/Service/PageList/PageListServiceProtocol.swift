import SkavokNetworking

protocol PageListServiceProtocol {
    func requestPages() async throws -> [WPPost]
}
