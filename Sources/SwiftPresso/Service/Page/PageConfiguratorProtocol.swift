import SkavokNetworking

protocol PageConfiguratorProtocol {
    func pageRequest(id: Int) -> Request<WPPost>
}
