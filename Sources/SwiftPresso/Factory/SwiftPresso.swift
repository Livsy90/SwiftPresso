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
                backgroundColor: SPPreferences.shared.configuration.backgroundColor,
                accentColor: SPPreferences.shared.configuration.accentColor,
                textColor: SPPreferences.shared.configuration.textColor,
                homeIcon: SPPreferences.shared.configuration.homeIcon,
                tagIcon: SPPreferences.shared.configuration.tagIcon,
                pageIcon: SPPreferences.shared.configuration.pageIcon,
                categoryIcon: SPPreferences.shared.configuration.categoryIcon,
                isShowPageMenu: SPPreferences.shared.configuration.isShowPageMenu,
                isShowTagMenu: SPPreferences.shared.configuration.isShowTagMenu,
                isShowCategoryMenu: SPPreferences.shared.configuration.isShowCategoryMenu,
                postPerPage: SPPreferences.shared.configuration.postsPerPage,
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
        public static var accentColor: Color { SPPreferences.shared.configuration.accentColor }
        public static var textColor: Color { SPPreferences.shared.configuration.textColor }
        public static var isShowPageMenu: Bool { SPPreferences.shared.configuration.isShowPageMenu }
        public static var isShowTagMenu: Bool { SPPreferences.shared.configuration.isShowTagMenu }
        public static var isShowCategoryMenu: Bool { SPPreferences.shared.configuration.isShowCategoryMenu }
        public static var tagIcon: Image { SPPreferences.shared.configuration.tagIcon }
        public static var pageIcon: Image { SPPreferences.shared.configuration.pageIcon }
        public static var categoryIcon: Image { SPPreferences.shared.configuration.categoryIcon }
        public static var homeIcon: Image { SPPreferences.shared.configuration.homeIcon }
        
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
        
        public static var tagListProvider:  TagListProviderProtocol = {
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
