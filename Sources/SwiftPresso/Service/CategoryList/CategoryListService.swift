import SkavokNetworking

struct CategoryListService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any CategoryListConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some CategoryListConfiguratorProtocol
    ) {
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
