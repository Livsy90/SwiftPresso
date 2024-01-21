import Foundation

public struct WPPostMapper: WPPostMapperProtocol {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    public func mapPost(_ wpPost: WPPost) -> RefinedPost {
        RefinedPost(
            id: wpPost.id,
            date: dateFormatter.date(from: wpPost.date),
            title: wpPost.title.rendered,
            excerpt: wpPost.excerpt?.rendered ?? "",
            imgURL: URL(string: wpPost.embedded?.wpFeaturedMedia?.first?.sourceUrl ?? ""),
            link: URL(string: wpPost.link),
            content: wpPost.content.rendered,
            author: wpPost.author,
            tags: wpPost.tags ?? []
        )
    }
    
    public func mapPosts(_ wpPosts: [WPPost]) -> [RefinedPost] {
        wpPosts.map { mapPost($0) }
    }
    
}
