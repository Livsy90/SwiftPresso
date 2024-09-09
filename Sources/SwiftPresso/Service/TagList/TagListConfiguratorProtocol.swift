import SkavokNetworking

protocol TagListConfiguratorProtocol {
    func tagsRequest() -> Request<[CategoryModel]>
}
