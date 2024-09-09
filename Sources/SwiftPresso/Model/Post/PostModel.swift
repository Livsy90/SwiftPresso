import Foundation.NSDate

public struct PostModel {
    public let id: Int
    public let date: Date?
    public let title: String
    public let excerpt: String
    public let imgURL: URL?
    public let link: URL?
    public let content: String
    public let author: Int
    public let tags: [Int]
}

extension PostModel: Hashable {
    public static func == (lhs: PostModel, rhs: PostModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
