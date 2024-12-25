struct PostProvider: PostProviderProtocol {
        
    private let service: any PostServiceProtocol
    private let mapper: any WPPostMapperProtocol
    
    init(service: some PostServiceProtocol, mapper: some WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    func getPost(id: Int, password: String?) async throws -> PostModel {
        do {
            let post = try await service.requestPost(id: id, password: password)
            let mapped = mapper.mapPost(post)
            return mapped
        } catch {
            throw error
        }
    }
    
    func getRawPost(id: Int, password: String?) async throws -> WPPost {
        do {
            return try await service.requestPost(id: id, password: password)
        } catch {
            throw error
        }
    }
    
}
