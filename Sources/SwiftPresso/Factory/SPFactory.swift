import Foundation

public enum SPFactory {
    
    public static func postListManager(
        host: String = SPSettings.shared.host,
        httpScheme: HTTPScheme = SPSettings.shared.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPSettings.shared.httpAdditionalHeaders
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
        
    public static func pageListManager(
        host: String = SPSettings.shared.host,
        httpScheme: HTTPScheme = SPSettings.shared.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPSettings.shared.httpAdditionalHeaders
    ) -> PageListManagerProtocol {
        
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
        let configurator = PageListServiceConfigurator()
        let mapper = WPPostMapper()
        let service = PageListService(
            networkClient: client,
            configurator: configurator
        )
        
        return PageListManager(
            service: service,
            mapper: mapper
        )
    }
    
    public static func categoryListManager(
        host: String = SPSettings.shared.host,
        httpScheme: HTTPScheme = SPSettings.shared.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPSettings.shared.httpAdditionalHeaders
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
    
    public static func tagListManager(
        host: String = SPSettings.shared.host,
        httpScheme: HTTPScheme = SPSettings.shared.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPSettings.shared.httpAdditionalHeaders
    ) ->  TagListManagerProtocol {
        
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
        let configurator = TagListServiceConfigurator()
        let service = TagListService(
            networkClient: client,
            configurator: configurator
        )
        
        return TagListManager(
            service: service
        )
    }
    
}
