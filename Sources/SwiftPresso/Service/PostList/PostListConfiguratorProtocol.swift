import SkavokNetworking

public protocol PostListConfiguratorProtocol {
    func feedRequest(
        pageNumber: Int,
        perPage: Int,
        categories: [Int]?,
        tags: [Int]?
    ) -> Request<[WPPost]>
}
