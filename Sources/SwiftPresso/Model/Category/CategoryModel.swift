import Foundation

public struct CategoryModel: Decodable {
    public let id: Int
    public let count: Int
    public let name: String
}

extension CategoryModel: Hashable {
    public static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
