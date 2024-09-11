import SkavokNetworking

protocol PageServiceProtocol {
    func requestPage(id: Int) async throws -> WPPost
}
