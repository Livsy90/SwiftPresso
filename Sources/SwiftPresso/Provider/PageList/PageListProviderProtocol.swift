public protocol PageListProviderProtocol {
    func getPages() async throws -> [PostModel]
    func getRawPages() async throws -> [WPPost]
}
