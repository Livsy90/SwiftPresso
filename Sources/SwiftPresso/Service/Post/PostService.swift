import SkavokNetworking

struct PostService {
    private let networkClient: any ApiClientProtocol
    private let configurator: any PostConfiguratorProtocol
    
    init(
        networkClient: some ApiClientProtocol,
        configurator: some PostConfiguratorProtocol
    ) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension PostService: PostServiceProtocol {
    
    func requestPost(id: Int) async throws -> WPPost {
        let request: Request<WPPost> = configurator.postRequest(id: id)
        return try await networkClient.send(request).value
    }
    
}
