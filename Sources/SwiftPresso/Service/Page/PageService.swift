import SkavokNetworking

struct PageService {
    private let networkClient: ApiClientProtocol
    private let configurator: PageConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: PageConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension PageService: PageServiceProtocol {
    
    func requestPage(id: Int) async throws -> WPPost {
        let request: Request<WPPost> = configurator.pageRequest(id: id)
        return try await networkClient.send(request).value
    }
    
}
