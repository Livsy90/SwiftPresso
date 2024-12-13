import SkavokNetworking

protocol TagListConfiguratorProtocol: Sendable {
    func tagsRequest() -> Request<[CategoryModel]>
}
