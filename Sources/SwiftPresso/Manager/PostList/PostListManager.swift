public struct PostListManager: PostListManagerProtocol {
        
    private let service: PostListServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    public init(service: PostListServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    public func getPosts(
        pageNumber: Int,
        perPage: Int,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [RefinedPost] {
        
        do {
            let posts = try await service.requestPosts(
                pageNumber: pageNumber,
                perPage: perPage,
                categories: categories,
                tags: tags
            )
            return mapper.mapPosts(posts)
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
}
