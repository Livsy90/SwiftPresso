public struct CategoryListManager: CategoryListManagerProtocol {
        
    private let service: CategoryListServiceProtocol
    
    public init(service: CategoryListServiceProtocol) {
        self.service = service
    }
    
    public func getCategories() async throws -> [Category] {
        do {
            let posts = try await service.requestCategories()
            return posts
        } catch {
            throw error
        }
    }
    
}
