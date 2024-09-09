import SkavokNetworking

protocol TagListServiceProtocol {
    func requestTags() async throws -> [CategoryModel]
}
