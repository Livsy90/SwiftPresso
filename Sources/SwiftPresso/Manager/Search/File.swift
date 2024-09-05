public struct SearchManager: SearchManagerProtocol {
    
    private let service: SearchServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    public init(service: SearchServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    public func getPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String
    ) async throws -> [RefinedPost] {
        
        do {
            let posts = try await service.requestPosts(
                pageNumber: pageNumber,
                searchTerms: searchTerms,
                perPage: perPage
            )
            return mapper.mapPosts(posts)
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
}
