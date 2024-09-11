import SkavokNetworking

struct PostServiceConfigurator: PostConfiguratorProtocol {

    func postRequest(id: Int) -> Request<WPPost> {
        let path = Endpoint.path(for: .posts).appending("/\(id)")
        
        return Request(path: path)
    }
    
}
