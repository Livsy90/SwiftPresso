import SkavokNetworking

protocol CategoryListServiceProtocol {
    func requestCategories() async throws -> [CategoryModel]
}
