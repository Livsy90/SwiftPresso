import SkavokNetworking

public struct CategoryListService {
    private let networkClient: ApiClientProtocol
    private let configurator: CategoryListConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: CategoryListConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension CategoryListService: CategoryListServiceProtocol {
    public func requestCategories() async throws -> [Category] {
        let request: Request<[Category]> = configurator.categoriesRequest()
        return try await networkClient.send(request).value
    }
}
