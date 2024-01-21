import Foundation.NSDate

public struct RefinedPost {
    let id: Int
    let date: Date?
    let title: String
    let excerpt: String
    let imgURL: URL?
    let link: URL?
    let content: String
    let author: Int
    let tags: [Int]
}
