import Foundation

public struct CategoryModel: Decodable, Sendable, Identifiable {
    public let id: Int
    public let count: Int
    public let name: String
    public let description: String
}

extension CategoryModel: Hashable {
    public static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CategoryModel {
    static let empty: Self = CategoryModel(id: .zero, count: .zero, name: "", description: "")
    static let all: Self = CategoryModel(id: .zero, count: .zero, name: "All", description: "")
    static let placeholder: Self = CategoryModel(id: .zero, count: .zero, name: "Placeholder", description: "")
}
