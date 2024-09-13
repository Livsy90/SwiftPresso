import SkavokNetworking

struct PageService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any PageConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some PageConfiguratorProtocol
    ) {
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
