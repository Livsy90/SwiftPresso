import SkavokNetworking

protocol CategoryListConfiguratorProtocol {
    func categoriesRequest() -> Request<[CategoryModel]>
}
