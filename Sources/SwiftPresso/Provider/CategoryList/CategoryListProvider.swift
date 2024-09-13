struct CategoryListProvider: CategoryListProviderProtocol {
        
    private let service: any CategoryListServiceProtocol
    
    init(service: some CategoryListServiceProtocol) {
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
