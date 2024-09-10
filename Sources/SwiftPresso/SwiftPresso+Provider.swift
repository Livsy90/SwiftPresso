import Foundation

extension SwiftPresso {
    
    /// Network providers factory methods.
    public enum Provider {
        
        /// Factory method for post list provider.
        /// - Returns: Returns the value of the provider of the post list.
        public static func postListProvider() -> PostListProviderProtocol {
            guard !Preferences.shared.configuration.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, use the 'SwiftPresso.Configuration.configure' method.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.shared.configuration.httpScheme.rawValue
            components.host = Preferences.shared.configuration.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.shared.configuration.httpScheme,
                httpAdditionalHeaders: nil
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
        
        /// Factory method for page list provider.
        /// - Returns: Returns the value of the page list provider.
        public static func pageListProvider() -> PageListProviderProtocol {
            guard !Preferences.shared.configuration.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.shared.configuration.httpScheme.rawValue
            components.host = Preferences.shared.configuration.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.shared.configuration.httpScheme,
                httpAdditionalHeaders: nil
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
        
        /// Factory method for category list provider.
        /// - Returns: Returns the value of the category list provider.
        public static func categoryListProvider() -> CategoryListProviderProtocol {
            guard !Preferences.shared.configuration.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.shared.configuration.httpScheme.rawValue
            components.host = Preferences.shared.configuration.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.shared.configuration.httpScheme,
                httpAdditionalHeaders: nil
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
        
        /// Factory method for tag list provider.
        /// - Returns: Returns the value of the tag list provider.
        public static func tagListProvider() -> TagListProviderProtocol {
            guard !Preferences.shared.configuration.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.shared.configuration.httpScheme.rawValue
            components.host = Preferences.shared.configuration.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.shared.configuration.httpScheme,
                httpAdditionalHeaders: nil
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
    
}
