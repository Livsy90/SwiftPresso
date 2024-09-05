import SkavokNetworking

public protocol TagListConfiguratorProtocol {
    func tagsRequest() -> Request<[Category]>
}
