import SkavokNetworking

struct PostListService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any PostListConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some PostListConfiguratorProtocol
    ) {
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
        tags: [Int]?,
        includeIDs: [Int]?
    ) async throws -> [WPPost] {
        
        let request: Request<[WPPost]> = configurator.feedRequest(
            pageNumber: pageNumber,
            perPage: perPage,
            searchTerms: searchTerms,
            categories: categories,
            tags: tags,
            includeIDs: includeIDs
        )
        return try await networkClient.send(request).value
    }
    
}
