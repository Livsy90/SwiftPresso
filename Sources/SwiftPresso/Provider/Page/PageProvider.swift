struct PageProvider: PageProviderProtocol {
        
    private let service: PageServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    init(service: PageServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    func getRefinedPage(id: Int) async throws -> PostModel {
        do {
            let page = try await service.requestPage(id: id)
            let mapped = mapper.mapPost(page)
            return mapped
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
    func getRawPage(id: Int) async throws -> WPPost {
        do {
            return try await service.requestPage(id: id)
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
}
