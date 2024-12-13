public protocol CategoryListProviderProtocol: Sendable {
    func getCategories() async throws -> [CategoryModel]
}
