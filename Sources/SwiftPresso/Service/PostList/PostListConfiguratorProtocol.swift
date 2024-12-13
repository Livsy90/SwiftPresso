import SkavokNetworking

protocol PostListConfiguratorProtocol: Sendable {
    func feedRequest(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?,
        includeIDs: [Int]?
    ) -> Request<[WPPost]>
}
