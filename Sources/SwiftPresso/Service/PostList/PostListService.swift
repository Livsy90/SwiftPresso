import SkavokNetworking

struct PostListService {
    private let networkClient: ApiClientProtocol
    private let configurator: PostListConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: PostListConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension PostListService: PostListServiceProtocol {
    
    func requestPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [WPPost] {
        
        let request: Request<[WPPost]> = configurator.feedRequest(
            pageNumber: pageNumber,
            perPage: perPage,
            searchTerms: searchTerms,
            categories: categories,
            tags: tags
        )
        return try await networkClient.send(request).value
    }
    
}
