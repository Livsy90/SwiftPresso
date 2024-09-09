import SkavokNetworking
import Foundation

struct APIClientFactory {
    static func client(
        url: URL, 
        httpScheme: HTTPScheme,
        httpAdditionalHeaders: [AnyHashable: Any]?
    ) -> APIClient {
        
        let sessionConfiguration: URLSessionConfiguration = .default
        sessionConfiguration.httpAdditionalHeaders = httpAdditionalHeaders
        let endpoint = url.settingScheme(httpScheme.rawValue)
        let clientConfiguration: APIClient.Configuration = .init(
            baseURL: endpoint,
            sessionConfiguration: sessionConfiguration
        )
        clientConfiguration.decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        return APIClient(configuration: clientConfiguration)
    }
}

fileprivate extension URL {
    func settingScheme(_ value: String) -> URL {
        let components = NSURLComponents.init(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = value
        return (components?.url!)!
    }
}

fileprivate extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
