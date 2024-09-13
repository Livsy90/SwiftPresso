import SkavokNetworking

struct PageListService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any PageListConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some PageListConfiguratorProtocol
    ) {
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
