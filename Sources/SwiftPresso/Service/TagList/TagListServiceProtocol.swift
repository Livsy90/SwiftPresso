import SkavokNetworking

public protocol TagListServiceProtocol {
    func requestTags() async throws -> [Category]
}
