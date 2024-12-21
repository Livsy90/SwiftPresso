import Foundation

public extension SwiftPresso {
    
    /// Network providers factory methods.
    enum Provider {
        
        /// Factory method for post list provider.
        /// - Returns: Returns the value of the provider of the post list.
        public static func postListProvider() -> some PostListProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, use the 'SwiftPresso.Configuration.configure' method.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
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
        
        /// Factory method for post provider.
        /// - Returns: Returns the value of the provider of the post.
        public static func postProvider() -> some PostProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, use the 'SwiftPresso.Configuration.configure' method.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
                httpAdditionalHeaders: nil
            )
            let configurator = PostServiceConfigurator()
            let mapper = WPPostMapper()
            let service = PostService(
                networkClient: client,
                configurator: configurator
            )
            
            return PostProvider(
                service: service,
                mapper: mapper
            )
        }
        
        /// Factory method for page list provider.
        /// - Returns: Returns the value of the page list provider.
        public static func pageListProvider() -> some PageListProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
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
        
        /// Factory method for page provider.
        /// - Returns: Returns the value of the page provider.
        public static func pageProvider() -> some PageProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
                httpAdditionalHeaders: nil
            )
            let configurator = PageServiceConfigurator()
            let mapper = WPPostMapper()
            let service = PageService(
                networkClient: client,
                configurator: configurator
            )
            
            return PageProvider(
                service: service,
                mapper: mapper
            )
        }
        
        /// Factory method for category list provider.
        /// - Returns: Returns the value of the category list provider.
        public static func categoryListProvider() -> some CategoryListProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
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
        public static func tagListProvider() -> some TagListProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
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
        
        /// Factory method for user provider.
        /// - Returns: Returns the value of the user provider.
        /// - Parameters:
        ///   - adminUsername: The name of the user with administrator rights.
        ///   - appPassword: The application password.
        public static func userProvider(
            adminUsername: String,
            appPassword: String
        ) -> some UserProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let credentialString = "\(adminUsername):\(appPassword)"
            
            guard let data = credentialString.data(using: .utf8) else {
                fatalError("SwiftPresso: Invalid credential")
            }
            let base64EncodedString = data.base64EncodedString()
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
                httpAdditionalHeaders: [
                    "authorization": "Basic \(base64EncodedString)"
                ]
            )
            let configurator = UserServiceConfigurator()
            let service = UserService(
                networkClient: client,
                configurator: configurator
            )
            
            return UserProvider(
                service: service
            )
        }
        
        public static func authProvider() -> some UserProviderProtocol {
            guard !Preferences.host.isEmpty else {
                fatalError("The host value must not be empty. To configure it, set the 'SwiftPresso.Configuration.configure' value.")
            }
            
            var components = URLComponents()
            components.scheme = Preferences.httpScheme.rawValue
            components.host = Preferences.host
            
            guard let url = components.url else {
                fatalError("SwiftPresso: Invalid URL")
            }
            
            let client = APIClientFactory.client(
                url: url,
                httpScheme: Preferences.httpScheme,
                httpAdditionalHeaders: nil
            )
            let configurator = UserServiceConfigurator()
            let service = UserService(
                networkClient: client,
                configurator: configurator
            )
            
            return UserProvider(
                service: service
            )
        }
        
    }
        
}
