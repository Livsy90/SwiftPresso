import SkavokNetworking

protocol PageListConfiguratorProtocol: Sendable {
    func pagesRequest() -> Request<[WPPost]>
}
