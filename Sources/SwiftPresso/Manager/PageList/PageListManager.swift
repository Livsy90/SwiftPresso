public struct PageListManager: PageListManagerProtocol {
        
    private let service: PageListServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    public init(service: PageListServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    public func getPages() async throws -> [RefinedPost] {
        do {
            let pages = try await service.requestPages()
            return mapper.mapPosts(pages)
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
}
