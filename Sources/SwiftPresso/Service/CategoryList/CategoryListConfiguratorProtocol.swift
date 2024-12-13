import SkavokNetworking

protocol CategoryListConfiguratorProtocol: Sendable {
    func categoriesRequest() -> Request<[CategoryModel]>
}
