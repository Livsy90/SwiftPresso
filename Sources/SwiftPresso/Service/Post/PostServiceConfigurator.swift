import SkavokNetworking

struct PostServiceConfigurator: PostConfiguratorProtocol {
    
    private enum Constants {
        enum Keys {
            static let password = "password"
        }
    }

    func postRequest(id: Int, password: String?) -> Request<WPPost> {
        var parameters: [(String, String)] = []
        
        if let password, !password.isEmpty {
            parameters.append((Constants.Keys.password, password))
        }
        
        let path = Endpoint.path(for: .post(id))
        
        return Request(
            path: path,
            query: parameters
        )
    }
    
}
