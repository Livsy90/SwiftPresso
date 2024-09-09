import SkavokNetworking

protocol PostListConfiguratorProtocol {
    func feedRequest(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) -> Request<[WPPost]>
}
