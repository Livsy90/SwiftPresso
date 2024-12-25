import SkavokNetworking

protocol PostServiceProtocol: Sendable {
    func requestPost(id: Int, password: String?) async throws -> WPPost
}
