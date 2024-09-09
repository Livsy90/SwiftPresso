public protocol PageListProviderProtocol {
    func getPages() async throws -> [PostModel]
}
