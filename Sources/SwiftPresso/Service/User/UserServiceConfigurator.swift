import SkavokNetworking

struct UserServiceConfigurator {
    
    private enum Constants {
        enum Keys {
            static let username = "username"
            static let password = "password"
            static let email = "email"
            static let description = "description"
        }
    }
    
}

extension UserServiceConfigurator: UserConfiguratorProtocol {
    
    func registerRequest(
        username: String,
        email: String,
        password: String
    ) -> Request<UserResponse> {
        
        let parameters: [(String, String)] = [
            (Constants.Keys.username, username),
            (Constants.Keys.password, password),
            (Constants.Keys.email, email)
        ]
        
        let path = Endpoint.path(for: .users)
        
        return Request(
            path: path,
            method: .post,
            query: parameters
        )
    }
    
    func editRequest(
        id: Int,
        email: String?,
        password: String?,
        description: String?
    ) -> Request<UserResponse> {
        
        var parameters: [(String, String)] = []
        
        if let email, !email.isEmpty {
            parameters.append((Constants.Keys.email, email))
        }
        
        if let password, !password.isEmpty {
            parameters.append((Constants.Keys.password, password))
        }
        
        if let description, !description.isEmpty {
            parameters.append((Constants.Keys.description, description))
        }
        
        let path = Endpoint.path(for: .userEdit(id))
        
        return Request(
            path: path,
            method: .post,
            query: parameters
        )
    }
    
    func loginRequest(
        username: String,
        password: String
    ) -> Request<LoginResponse> {
        
        let path = Endpoint.path(for: .login)
        let bodyModel = LoginRequest(
            username: username,
            password: password
        )
        
        return Request(
            path: path,
            method: .get,
            body: bodyModel
        )
    }
    
}
