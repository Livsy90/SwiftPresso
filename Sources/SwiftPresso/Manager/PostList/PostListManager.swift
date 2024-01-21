public struct PostListManager: PostListManagerProtocol {
        
    private let service: PostListServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    public init(service: PostListServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    public func getPosts(pageNumber: Int) async throws -> [RefinedPost] {
        do {
            let posts = try await service.requestPosts(pageNumber: pageNumber)
            return mapper.mapPosts(posts)
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
}
