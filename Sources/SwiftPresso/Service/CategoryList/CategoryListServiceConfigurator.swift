import SkavokNetworking

public struct CategoryListServiceConfigurator: CategoryListConfiguratorProtocol {
    public func categoriesRequest() -> Request<[Category]> {
        let path = Endpoint.path(for: .categories)
        
        return Request(path: path)
    }
}
