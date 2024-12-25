import Foundation

extension SwiftPresso {
    static func get<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode(type.self, from: data)
    }
}
