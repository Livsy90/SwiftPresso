import SkavokNetworking

protocol CategoryListServiceProtocol: Sendable {
    func requestCategories() async throws -> [CategoryModel]
}
