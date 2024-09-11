import SkavokNetworking

protocol PostServiceProtocol {
    func requestPost(id: Int) async throws -> WPPost
}
