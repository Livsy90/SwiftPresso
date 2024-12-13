protocol WPPostMapperProtocol: Sendable {
    func mapPost(_ wpPost: WPPost) -> PostModel
    func mapPosts(_ wpPosts: [WPPost]) -> [PostModel]
}
