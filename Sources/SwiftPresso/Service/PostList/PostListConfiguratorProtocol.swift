import SkavokNetworking

public protocol PostListConfiguratorProtocol {
    func feedRequest(pageNumber: Int) -> Request<[WPPost]>
}
