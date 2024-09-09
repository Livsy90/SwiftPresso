import SkavokNetworking

struct PageListServiceConfigurator: PageListConfiguratorProtocol {

    func pagesRequest() -> Request<[WPPost]> {
        let path = Endpoint.path(for: .pages)
        
        return Request(path: path)
    }
    
}
