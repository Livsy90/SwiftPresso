import SkavokNetworking

public protocol SearchConfiguratorProtocol {
    func feedRequest(
        pageNumber: Int,
        searchTerms: String,
        perPage: Int
    ) -> Request<[WPPost]>
}
