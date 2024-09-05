import SkavokNetworking

public protocol CategoryListServiceProtocol {
    func requestCategories() async throws -> [Category]
}
