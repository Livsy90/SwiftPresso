import SkavokNetworking

struct TagListServiceConfigurator: TagListConfiguratorProtocol {
    func tagsRequest() -> Request<[CategoryModel]> {
        let path = Endpoint.path(for: .tags)
        
        return Request(path: path)
    }
}
