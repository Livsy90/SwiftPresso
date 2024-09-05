import SkavokNetworking

public protocol CategoryListConfiguratorProtocol {
    func categoriesRequest() -> Request<[Category]>
}
