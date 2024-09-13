struct PageListProvider: PageListProviderProtocol {
        
    private let service: any PageListServiceProtocol
    private let mapper: any WPPostMapperProtocol
    
    init(
        service: some PageListServiceProtocol,
        mapper: some WPPostMapperProtocol
    ) {
        self.service = service
        self.mapper = mapper
    }
    
    func getPages() async throws -> [PostModel] {
        do {
            let pages = try await service.requestPages()
            return mapper.mapPosts(pages)
        } catch {
            throw error
        }
    }
    
    func getRawPages() async throws -> [WPPost] {
        do {
            let pages = try await service.requestPages()
            return pages
        } catch {
            throw error
        }
    }
    
}
