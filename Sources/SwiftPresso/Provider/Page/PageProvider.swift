struct PageProvider: PageProviderProtocol {
        
    private let service: any PageServiceProtocol
    private let mapper: any WPPostMapperProtocol
    
    init(
        service: some PageServiceProtocol,
        mapper: some WPPostMapperProtocol
    ) {
        self.service = service
        self.mapper = mapper
    }
    
    func getPage(id: Int) async throws -> PostModel {
        do {
            let page = try await service.requestPage(id: id)
            let mapped = mapper.mapPost(page)
            return mapped
        } catch {
            throw error
        }
    }
    
    func getRawPage(id: Int) async throws -> WPPost {
        do {
            return try await service.requestPage(id: id)
        } catch {
            throw error
        }
    }
    
}
