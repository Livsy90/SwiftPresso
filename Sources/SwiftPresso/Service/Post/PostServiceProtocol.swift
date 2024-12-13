import SkavokNetworking

protocol PostServiceProtocol: Sendable {
    func requestPost(id: Int) async throws -> WPPost
}
