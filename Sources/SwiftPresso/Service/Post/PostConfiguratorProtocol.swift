import SkavokNetworking

protocol PostConfiguratorProtocol: Sendable {
    func postRequest(id: Int) -> Request<WPPost>
}
