import Foundation.NSDate

public struct RefinedPost {
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
