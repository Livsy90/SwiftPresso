public protocol TagListProviderProtocol {
    func getTags() async throws -> [CategoryModel]
}
