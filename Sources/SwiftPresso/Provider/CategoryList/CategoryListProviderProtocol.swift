public protocol CategoryListProviderProtocol {
    func getCategories() async throws -> [CategoryModel]
}
