import SkavokNetworking

public protocol PostListConfiguratorProtocol {
    func feedRequest(pageNumber: Int, perPage: Int, categories: [Int]?) -> Request<[WPPost]>
}
