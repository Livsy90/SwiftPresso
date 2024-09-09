public protocol PageListManagerProtocol {
    func getPages() async throws -> [PostModel]
}
