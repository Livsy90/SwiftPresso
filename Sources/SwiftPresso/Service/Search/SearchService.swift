import SkavokNetworking

public struct SearchService {
    private let networkClient: ApiClientProtocol
    private let configurator: SearchConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: SearchConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension SearchService: SearchServiceProtocol {
    
    public func requestPosts(
        pageNumber: Int,
        searchTerms: String,
        perPage: Int
    ) async throws -> [WPPost] {
        let request: Request<[WPPost]> = configurator.feedRequest(
            pageNumber: pageNumber,
            searchTerms: searchTerms,
            perPage: perPage
        )
        return try await networkClient.send(request).value
    }
    
}
