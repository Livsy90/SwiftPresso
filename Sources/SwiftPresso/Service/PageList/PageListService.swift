import SkavokNetworking

struct PageListService {
    private let networkClient: ApiClientProtocol
    private let configurator: PageListConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: PageListConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension PageListService: PageListServiceProtocol {
    
    func requestPages() async throws -> [WPPost] {
        let request: Request<[WPPost]> = configurator.pagesRequest()
        return try await networkClient.send(request).value
    }
    
}
