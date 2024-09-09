struct TagListProvider: TagListProviderProtocol {
        
    private let service: TagListServiceProtocol
    
    init(service: TagListServiceProtocol) {
        self.service = service
    }
    
    func getTags() async throws -> [CategoryModel] {
        do {
            let tags = try await service.requestTags()
            return tags
        } catch {
            throw error
        }
    }
    
}
