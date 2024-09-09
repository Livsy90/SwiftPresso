import SkavokNetworking

struct TagListService {
    private let networkClient: ApiClientProtocol
    private let configurator: TagListConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: TagListConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension TagListService: TagListServiceProtocol {
    func requestTags() async throws -> [CategoryModel] {
        let request: Request<[CategoryModel]> = configurator.tagsRequest()
        return try await networkClient.send(request).value
    }
}
