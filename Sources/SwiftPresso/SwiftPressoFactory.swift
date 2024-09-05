import Foundation

public enum SwiftPressoFactory {
    
    public static func postListManager(
        host: String,
        httpScheme: HTTPScheme,
        httpAdditionalHeaders: [AnyHashable: Any]?
    ) -> PostListManagerProtocol {
        
        var components = URLComponents()
        components.scheme = httpScheme.rawValue
        components.host = host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: httpScheme,
            httpAdditionalHeaders: httpAdditionalHeaders
        )
        let configurator = PostListServiceConfigurator()
        let mapper = WPPostMapper()
        let service = PostListService(
            networkClient: client,
            configurator: configurator
        )
        
        return PostListManager(
            service: service,
            mapper: mapper
        )
    }
    
    public static func categoryListManager(
        host: String,
        httpScheme: HTTPScheme,
        httpAdditionalHeaders: [AnyHashable: Any]?
    ) ->  CategoryListManagerProtocol {
        
        var components = URLComponents()
        components.scheme = httpScheme.rawValue
        components.host = host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: httpScheme,
            httpAdditionalHeaders: httpAdditionalHeaders
        )
        let configurator = CategoryListServiceConfigurator()
        let service = CategoryListService(
            networkClient: client,
            configurator: configurator
        )
        
        return CategoryListManager(
            service: service
        )
    }
    
}
