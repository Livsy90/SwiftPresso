import SkavokNetworking

protocol TagListServiceProtocol: Sendable {
    func requestTags() async throws -> [CategoryModel]
}
