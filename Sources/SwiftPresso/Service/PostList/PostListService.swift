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
    
    public func requestPosts(
        pageNumber: Int,
        perPage: Int,
        categories: [Int]?
    ) async throws -> [WPPost] {
        
        let request: Request<[WPPost]> = configurator.feedRequest(
            pageNumber: pageNumber,
            perPage: perPage,
            categories: categories
        )
        return try await networkClient.send(request).value
    }
    
}
