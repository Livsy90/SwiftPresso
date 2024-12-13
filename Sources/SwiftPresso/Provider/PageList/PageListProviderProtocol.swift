public protocol PageListProviderProtocol: Sendable {
    func getPages() async throws -> [PostModel]
    func getRawPages() async throws -> [WPPost]
}
