public protocol CategoryListManagerProtocol {
    func getCategories() async throws -> [CategoryModel]
}
