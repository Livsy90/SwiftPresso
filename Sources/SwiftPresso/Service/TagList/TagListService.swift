import SkavokNetworking

struct TagListService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any TagListConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some TagListConfiguratorProtocol
    ) {
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
