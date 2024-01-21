import SkavokNetworking

public struct PostListService {
    private let networkClient: ApiClientProtocol
    private let configurator: PostListConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: PostListConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension PostListService: PostListServiceProtocol {
    
    public func requestPosts(pageNumber: Int) async throws -> [WPPost] {
        let request: Request<[WPPost]> = configurator.feedRequest(pageNumber: pageNumber)
        return try await networkClient.send(request).value
    }
    
}
