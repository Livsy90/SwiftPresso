struct PostProvider: PostProviderProtocol {
        
    private let service: PostServiceProtocol
    private let mapper: WPPostMapperProtocol
    
    init(service: PostServiceProtocol, mapper: WPPostMapperProtocol) {
        self.service = service
        self.mapper = mapper
    }
    
    func getRefinedPost(id: Int) async throws -> PostModel {
        do {
            let post = try await service.requestPost(id: id)
            let mapped = mapper.mapPost(post)
            return mapped
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
    func getRawPost(id: Int) async throws -> WPPost {
        do {
            return try await service.requestPost(id: id)
        } catch {
            throw WPPostMapperError.mapperError
        }
    }
    
}