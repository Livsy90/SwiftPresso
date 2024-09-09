import SkavokNetworking

struct CategoryListServiceConfigurator: CategoryListConfiguratorProtocol {
    func categoriesRequest() -> Request<[CategoryModel]> {
        let path = Endpoint.path(for: .categories)
        
        return Request(path: path)
    }
}
