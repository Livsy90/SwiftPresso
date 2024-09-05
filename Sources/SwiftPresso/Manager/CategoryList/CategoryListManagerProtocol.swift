public protocol CategoryListManagerProtocol {
    func getCategories() async throws -> [Category]
}
