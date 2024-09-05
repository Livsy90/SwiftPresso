import SkavokNetworking

public struct TagListService {
    private let networkClient: ApiClientProtocol
    private let configurator: TagListConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: TagListConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension TagListService: TagListServiceProtocol {
    public func requestTags() async throws -> [Category] {
        let request: Request<[Category]> = configurator.tagsRequest()
        return try await networkClient.send(request).value
    }
}
