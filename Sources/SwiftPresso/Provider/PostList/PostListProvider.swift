struct PostListProvider: PostListProviderProtocol {
        
    private let service: any PostListServiceProtocol
    private let mapper: any WPPostMapperProtocol
    
    init(service: some PostListServiceProtocol, mapper: some WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    func getPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [PostModel] {
        
        do {
            let posts = try await service.requestPosts(
                pageNumber: pageNumber,
                perPage: perPage,
                searchTerms: searchTerms,
                categories: categories,
                tags: tags
            )
            let mapped = mapper.mapPosts(posts)
            return mapped
        } catch {
            throw error
        }
    }
    
    func getRawPosts(
        pageNumber: Int,
        perPage: Int,
        searchTerms: String?,
        categories: [Int]?,
        tags: [Int]?
    ) async throws -> [WPPost] {
        
        do {
            let posts = try await service.requestPosts(
                pageNumber: pageNumber,
                perPage: perPage,
                searchTerms: searchTerms,
                categories: categories,
                tags: tags
            )
            return posts
        } catch {
            throw error
        }
    }
    
}
