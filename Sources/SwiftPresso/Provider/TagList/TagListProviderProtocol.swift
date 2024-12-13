public protocol TagListProviderProtocol: Sendable {
    func getTags() async throws -> [CategoryModel]
}
