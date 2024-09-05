public struct TagListManager: TagListManagerProtocol {
        
    private let service: TagListServiceProtocol
    
    public init(service: TagListServiceProtocol) {
        self.service = service
    }
    
    public func getTags() async throws -> [Category] {
        do {
            let tags = try await service.requestTags()
            return tags
        } catch {
            throw error
        }
    }
    
}
