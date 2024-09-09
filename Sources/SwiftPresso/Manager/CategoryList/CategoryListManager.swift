struct CategoryListManager: CategoryListManagerProtocol {
        
    private let service: CategoryListServiceProtocol
    
    init(service: CategoryListServiceProtocol) {
        self.service = service
    }
    
    func getCategories() async throws -> [CategoryModel] {
        do {
            let categories = try await service.requestCategories()
            return categories
        } catch {
            throw error
        }
    }
    
}
