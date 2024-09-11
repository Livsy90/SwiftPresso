public protocol PageProviderProtocol {
    func getPage(id: Int) async throws -> PostModel
    func getRawPage(id: Int) async throws -> WPPost
}
