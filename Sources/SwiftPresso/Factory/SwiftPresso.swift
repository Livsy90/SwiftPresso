import Foundation
import SwiftUI

public enum SwiftPresso {
    
    public enum View {
        
        public static func postListView<Placeholder: SwiftUI.View>(
            configuration: SPConfiguration,
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            Configuration.configure(with: configuration)
            
            return SPPostListView(
                backgroundColor: Configuration.backgroundColor,
                interfaceColor: Configuration.interfaceColor,
                textColor: Configuration.textColor,
                menuBackgroundColor: Configuration.menuBackgroundColor,
                menuTextColor: Configuration.textColor,
                homeIcon: Configuration.homeIcon,
                isShowPageMenu: Configuration.isShowPageMenu,
                isShowTagMenu: Configuration.isShowTagMenu,
                isShowCategoryMenu: Configuration.isShowCategoryMenu,
                pageMenuTitle: Configuration.pageMenuTitle,
                tagMenuTitle: Configuration.tagMenuTitle,
                categoryMenuTitle: Configuration.categoryMenuTitle,
                postPerPage: Configuration.postsPerPage,
                loadingPlaceholder: placeholder
            )
        }
        
        public static func shimmerPlaceholderView(backgroundColor: Color = Configuration.backgroundColor) -> some SwiftUI.View {
            SPShimmerPlacehodler(backgroundColor: backgroundColor)
        }
        
    }
    
    public enum Configuration {
        
        public static var host: String { SPPreferences.shared.configuration.host }
        public static var postsPerPage: Int { SPPreferences.shared.configuration.postsPerPage }
        public static var httpScheme: HTTPScheme { SPPreferences.shared.configuration.httpScheme }
        public static var httpAdditionalHeaders: [AnyHashable: Any]? { SPPreferences.shared.configuration.httpAdditionalHeaders }
        public static var isExcludeWebHeaderAndFooter: Bool { SPPreferences.shared.configuration.isExcludeWebHeaderAndFooter }
        public static var backgroundColor: Color { SPPreferences.shared.configuration.backgroundColor }
        public static var interfaceColor: Color { SPPreferences.shared.configuration.interfaceColor }
        public static var textColor: Color { SPPreferences.shared.configuration.textColor }
        public static var isShowPageMenu: Bool { SPPreferences.shared.configuration.isShowPageMenu }
        public static var isShowTagMenu: Bool { SPPreferences.shared.configuration.isShowTagMenu }
        public static var isShowCategoryMenu: Bool { SPPreferences.shared.configuration.isShowCategoryMenu }
        public static var homeIcon: Image { SPPreferences.shared.configuration.homeIcon }
        public static var pageMenuTitle: String { SPPreferences.shared.configuration.pageMenuTitle }
        public static var tagMenuTitle: String { SPPreferences.shared.configuration.tagMenuTitle }
        public static var categoryMenuTitle: String { SPPreferences.shared.configuration.categoryMenuTitle }
        public static var menuBackgroundColor: Color { SPPreferences.shared.configuration.menuBackgroundColor }
        public static var menuTextColor: Color { SPPreferences.shared.configuration.menuTextColor }
        
        public static func configure(with configuration: SPConfiguration) {
            SPPreferences.shared.configuration = configuration
        }
    }
    
    public enum Provider {
        
        public static var postListProvider: PostListProviderProtocol = {
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
        }()
        
        public static var pageListProvider: PageListProviderProtocol = {
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
        }()
        
        public static var categoryListProvider: CategoryListProviderProtocol = {
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
        }()
        
        public static var tagListProvider: TagListProviderProtocol = {
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
        }()
        
    }
    
}
