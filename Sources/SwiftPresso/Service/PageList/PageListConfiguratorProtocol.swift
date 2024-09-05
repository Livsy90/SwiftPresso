import SkavokNetworking

public protocol PageListConfiguratorProtocol {
    func pagesRequest() -> Request<[WPPost]>
}
