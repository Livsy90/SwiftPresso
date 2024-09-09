protocol WPPostMapperProtocol {
    func mapPost(_ wpPost: WPPost) -> PostModel
    func mapPosts(_ wpPosts: [WPPost]) -> [PostModel]
}
