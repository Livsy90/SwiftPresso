import Foundation

struct WPPostMapper: WPPostMapperProtocol {
    
    private enum ClassListOption: String {
        case password = "post-password-required"
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
        
    func mapPost(_ wpPost: WPPost) -> PostModel {
        PostModel(
            id: wpPost.id,
            date: dateFormatter.date(from: wpPost.date),
            title: wpPost.title.rendered,
            excerpt: wpPost.excerpt?.rendered ?? "",
            imgURL: URL(string: wpPost.embedded?.wpFeaturedMedia?.first?.sourceUrl ?? ""),
            link: URL(string: wpPost.link),
            content: wpPost.content.rendered,
            author: wpPost.author,
            tags: wpPost.tags ?? [],
            isPasswordProtected: wpPost.classList?.contains(ClassListOption.password.rawValue) ?? false
        )
    }
    
    func mapPosts(_ wpPosts: [WPPost]) -> [PostModel] {
        wpPosts.map { mapPost($0) }
    }
    
}
