import SkavokNetworking

protocol PostConfiguratorProtocol: Sendable {
    func postRequest(id: Int, password: String?) -> Request<WPPost>
}
