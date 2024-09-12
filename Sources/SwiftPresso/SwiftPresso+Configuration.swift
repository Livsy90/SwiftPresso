import Foundation
import SwiftUI

public enum SwiftPresso {
    
    /// SwiftPresso configuration.
    public enum Configuration {
        
        /// API host.
        public static var host: String { Preferences.shared.configuration.host }
        
        /// Posts per page in the post list.
        public static var postsPerPage: Int { Preferences.shared.configuration.postsPerPage }
        
        /// API HTTP scheme.
        public static var httpScheme: HTTPScheme { Preferences.shared.configuration.httpScheme }
        
        /// Remove web page's header and footer.
        public static var isExcludeWebHeaderAndFooter: Bool { Preferences.shared.configuration.isExcludeWebHeaderAndFooter }
        
        /// Post list and web view background color.
        public static var backgroundColor: Color { Preferences.shared.configuration.backgroundColor }
        
        /// Post list and web view interface color.
        public static var interfaceColor: Color { Preferences.shared.configuration.interfaceColor }
        
        /// Post list and web view text color.
        public static var textColor: Color { Preferences.shared.configuration.textColor }
        
        /// Determines the visibility of the page menu.
        public static var isShowPageMenu: Bool { Preferences.shared.configuration.isShowPageMenu }
        
        /// Determines the visibility of the tag menu.
        public static var isShowTagMenu: Bool { Preferences.shared.configuration.isShowTagMenu }
        
        /// Determines the visibility of the category menu.
        public static var isShowCategoryMenu: Bool { Preferences.shared.configuration.isShowCategoryMenu }
        
        /// Home icon.
        public static var homeIcon: Image { Preferences.shared.configuration.homeIcon }
        
        /// Determines the title of the page menu.
        public static var pageMenuTitle: String { Preferences.shared.configuration.pageMenuTitle }
        
        /// Determines the title of the tag menu.
        public static var tagMenuTitle: String { Preferences.shared.configuration.tagMenuTitle }
        
        /// Determines the title of the category menu.
        public static var categoryMenuTitle: String { Preferences.shared.configuration.categoryMenuTitle }
        
        /// Home screen navigation title.
        public static var homeTitle: String? { Preferences.shared.configuration.homeTitle }
        
        /// Search screen navigation title.
        public static var searchTitle: String? { Preferences.shared.configuration.searchTitle }
        
        /// Menu background color.
        public static var menuBackgroundColor: Color { Preferences.shared.configuration.menuBackgroundColor }
        
        /// Menu text color.
        public static var menuTextColor: Color { Preferences.shared.configuration.menuTextColor }
        
        /// To expand menu items by default.
        public static var isMenuExpanded: Bool { Preferences.shared.configuration.isMenuExpanded }
        
        /// Using webview as post view.
        public static var isShowPostInWebView: Bool { Preferences.shared.configuration.isShowPostInWebView }
        
        /// Initial configuration.
        /// - Parameter configuration: configuration model.
        public static func configure(with configuration: SwiftPressoSettings) {
            Preferences.shared.configuration = configuration
        }
        
    }
    
}
