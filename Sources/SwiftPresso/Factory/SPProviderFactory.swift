import Foundation

public enum SwiftPresso {
    
    public static func configure(_ configuration: SPPreferences.Configuration) {
        SPPreferences.shared.configuration = configuration
    }
    
    public static func postListProvider() -> PostListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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
        
    public static func pageListProvider() -> PageListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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
    
    public static func categoryListProvider() ->  CategoryListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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
    
    public static func tagListProvider() ->  TagListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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

public enum SPProviderFactory {
    
    public static func postListProvider() -> PostListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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
        
    public static func pageListProvider() -> PageListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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
    
    public static func categoryListProvider() ->  CategoryListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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
    
    public static func tagListProvider() ->  TagListProviderProtocol {
        guard !SPPreferences.shared.configuration.host.isEmpty else {
            fatalError("The host value must not be empty. To configure it, set the 'SPPreferences.shared.configuration' value.")
        }
        
        var components = URLComponents()
        components.scheme = SPPreferences.shared.configuration.httpScheme.rawValue
        components.host = SPPreferences.shared.configuration.host
        
        guard let url = components.url else {
            fatalError("SwiftPresso: Invalid URL")
        }
        
        let client = APIClientFactory.client(
            url: url,
            httpScheme: SPPreferences.shared.configuration.httpScheme,
            httpAdditionalHeaders: SPPreferences.shared.configuration.httpAdditionalHeaders
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
