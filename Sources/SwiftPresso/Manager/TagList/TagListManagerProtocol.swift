public protocol TagListManagerProtocol {
    func getTags() async throws -> [Category]
}
