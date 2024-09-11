struct PostListProvider: PostListProviderProtocol {
        
    private let service: PostListServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    init(service: PostListServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    func getRefinedPosts(
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
            throw WPPostMapperError.mapperError
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
