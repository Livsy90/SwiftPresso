import SkavokNetworking

struct PostService {
    private let networkClient: ApiClientProtocol
    private let configurator: PostConfiguratorProtocol
    
    init(networkClient: ApiClientProtocol, configurator: PostConfiguratorProtocol) {
        self.networkClient = networkClient
        self.configurator = configurator
    }
}

extension PostService: PostServiceProtocol {
    
    func requestPost(id: Int) async throws -> WPPost {
        let request: Request<WPPost> = configurator.postRequest()
        return try await networkClient.send(request).value
    }
    
}
