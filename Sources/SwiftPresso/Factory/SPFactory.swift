import Foundation

public enum SPFactory {
    
    public static func postListProvider(
        host: String = SPConfigurator.shared.configuration.host,
        httpScheme: HTTPScheme = SPConfigurator.shared.configuration.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPConfigurator.shared.configuration.httpAdditionalHeaders
    ) -> PostListProviderProtocol {
        
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
        
        return PostListProvider(
            service: service,
            mapper: mapper
        )
    }
        
    public static func pageListProvider(
        host: String = SPConfigurator.shared.configuration.host,
        httpScheme: HTTPScheme = SPConfigurator.shared.configuration.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPConfigurator.shared.configuration.httpAdditionalHeaders
    ) -> PageListProviderProtocol {
        
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
        
        return PageListProvider(
            service: service,
            mapper: mapper
        )
    }
    
    public static func categoryListProvider(
        host: String = SPConfigurator.shared.configuration.host,
        httpScheme: HTTPScheme = SPConfigurator.shared.configuration.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPConfigurator.shared.configuration.httpAdditionalHeaders
    ) ->  CategoryListProviderProtocol {
        
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
        
        return CategoryListProvider(
            service: service
        )
    }
    
    public static func tagListProvider(
        host: String = SPConfigurator.shared.configuration.host,
        httpScheme: HTTPScheme = SPConfigurator.shared.configuration.httpScheme,
        httpAdditionalHeaders: [AnyHashable: Any]? = SPConfigurator.shared.configuration.httpAdditionalHeaders
    ) ->  TagListProviderProtocol {
        
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
        
        return TagListProvider(
            service: service
        )
    }
    
}
