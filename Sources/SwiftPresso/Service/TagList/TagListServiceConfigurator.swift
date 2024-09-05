import SkavokNetworking

public struct TagListServiceConfigurator: TagListConfiguratorProtocol {
    public func tagsRequest() -> Request<[Category]> {
        let path = Endpoint.path(for: .tags)
        
        return Request(path: path)
    }
}
