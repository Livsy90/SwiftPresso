struct PageListProvider: PageListProviderProtocol {
        
    private let service: PageListServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    init(service: PageListServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    func getPages() async throws -> [PostModel] {
        do {
            let pages = try await service.requestPages()
            return mapper.mapPosts(pages)
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
}
