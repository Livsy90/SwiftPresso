import SkavokNetworking

protocol PostConfiguratorProtocol {
    func postRequest(id: Int) -> Request<WPPost>
}
