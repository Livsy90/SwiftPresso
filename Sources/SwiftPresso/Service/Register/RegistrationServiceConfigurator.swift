import SkavokNetworking

struct RegistrationServiceConfigurator {
    
    private enum Constants {
        enum Keys {
            static let username = "username"
            static let password = "password"
            static let email = "email"
        }
    }
    
}

extension RegistrationServiceConfigurator: RegistrationConfiguratorProtocol {
    
    func registerRequest(
        username: String,
        email: String,
        password: String
    ) -> Request<RegisterModel> {
        
        let parameters: [(String, String)] = [
            (Constants.Keys.username, username),
            (Constants.Keys.password, password),
            (Constants.Keys.email, email)
        ]
        
        let path = Endpoint.path(for: .users)
        
        return Request(path: path, method: .post, query: parameters)
    }
    
}
