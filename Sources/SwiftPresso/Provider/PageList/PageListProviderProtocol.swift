public protocol PageListProviderProtocol {
    func getRefinedPages() async throws -> [PostModel]
    func getRawPages() async throws -> [WPPost]
}
