public protocol PageProviderProtocol {
    func getRefinedPage(id: Int) async throws -> PostModel
    func getRawPage(id: Int) async throws -> WPPost
}
