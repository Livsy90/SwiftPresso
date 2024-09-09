import SkavokNetworking

protocol PageListConfiguratorProtocol {
    func pagesRequest() -> Request<[WPPost]>
}
