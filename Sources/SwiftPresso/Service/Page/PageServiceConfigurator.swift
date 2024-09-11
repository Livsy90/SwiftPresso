import SkavokNetworking

struct PageServiceConfigurator: PageConfiguratorProtocol {

    func pageRequest(id: Int) -> Request<WPPost> {
        let path = Endpoint.path(for: .pages).appending("/\(id)")
        
        return Request(path: path)
    }
    
}
