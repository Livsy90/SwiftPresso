import SkavokNetworking

struct CategoryListService {
    private let networkClient: ApiClientProtocol
    private let configurator: CategoryListConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: CategoryListConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension CategoryListService: CategoryListServiceProtocol {
    func requestCategories() async throws -> [CategoryModel] {
        let request: Request<[CategoryModel]> = configurator.categoriesRequest()
        return try await networkClient.send(request).value
    }
}
