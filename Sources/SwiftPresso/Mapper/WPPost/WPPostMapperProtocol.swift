public protocol WPPostMapperProtocol {
    func mapPost(_ wpPost: WPPost) -> RefinedPost
    func mapPosts(_ wpPosts: [WPPost]) -> [RefinedPost]
}
