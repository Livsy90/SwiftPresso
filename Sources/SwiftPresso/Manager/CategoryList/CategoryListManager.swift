public struct CategoryListManager: CategoryListManagerProtocol {
        
    private let service: CategoryListServiceProtocol
    
    public init(service: CategoryListServiceProtocol) {
        self.service = service
    }
    
    public func getCategories() async throws -> [Category] {
        do {
            let categories = try await service.requestCategories()
            return categories
        } catch {
            throw error
        }
    }
    
}
