import Foundation
import SwiftUI

public extension SwiftPresso {
    
    /// SwiftPresso configuration.
    enum Configuration {
        
        public enum API {
            
            /// API host.
            public static var host: String { Preferences.shared.configuration.host }
            
            /// Posts per page in the post list request.
            public static var postsPerPage: Int { Preferences.shared.configuration.postsPerPage }
            
            /// API HTTP scheme.
            public static var httpScheme: HTTPScheme { Preferences.shared.configuration.httpScheme }
            
            /// API Tag path component.
            public static var tagPathComponent: String { Preferences.shared.configuration.tagPathComponent }
            
            /// API Category path component.
            public static var categoryPathComponent: String { Preferences.shared.configuration.categoryPathComponent }
            
        }
        
        public enum UI {
            
            /// Remove web page's header and footer.
            public static var isExcludeWebHeaderAndFooter: Bool { Preferences.shared.configuration.isExcludeWebHeaderAndFooter }
            
            /// Post list and post view background color.
            public static var backgroundColor: Color { Preferences.shared.configuration.backgroundColor }
            
            /// Post list font.
            public static var postListFont: Font { Preferences.shared.configuration.postListFont }
            
            /// Post body font.
            public static var postBodyFont: UIFont.TextStyle { Preferences.shared.configuration.postBodyFont }
            
            /// Post title font.
            public static var postTitleFont: Font { Preferences.shared.configuration.postTitleFont }
            
            /// Post list and post view interface color.
            public static var interfaceColor: Color { Preferences.shared.configuration.interfaceColor }
            
            /// Post list and post view text color.
            public static var textColor: Color { Preferences.shared.configuration.textColor }
            
            /// Determines the visibility of the page menu.
            public static var isShowPageMenu: Bool { Preferences.shared.configuration.isShowPageMenu }
            
            /// Determines the visibility of the tag menu.
            public static var isShowTagMenu: Bool { Preferences.shared.configuration.isShowTagMenu }
            
            /// Determines the visibility of the category menu.
            public static var isShowCategoryMenu: Bool { Preferences.shared.configuration.isShowCategoryMenu }
            
            /// The icon for the navigation bar button that restores the interface to its default state.
            public static var homeIcon: Image { Preferences.shared.configuration.homeIcon }
            
            /// Determines the title of the page menu.
            public static var pageMenuTitle: String { Preferences.shared.configuration.pageMenuTitle }
            
            /// Determines the title of the tag menu.
            public static var tagMenuTitle: String { Preferences.shared.configuration.tagMenuTitle }
            
            /// Determines the title of the category menu.
            public static var categoryMenuTitle: String { Preferences.shared.configuration.categoryMenuTitle }
            
            /// Navigation title for default state.
            public static var homeTitle: String { Preferences.shared.configuration.homeTitle }
            
            /// Navigation title for search state.
            public static var searchTitle: String { Preferences.shared.configuration.searchTitle }
            
            /// Menu background color.
            public static var menuBackgroundColor: Color { Preferences.shared.configuration.menuBackgroundColor }
            
            /// Menu text color.
            public static var menuTextColor: Color { Preferences.shared.configuration.menuTextColor }
            
            /// To expand menu items by default.
            public static var isMenuExpanded: Bool { Preferences.shared.configuration.isMenuExpanded }
            
            /// Using WKWebView as post view.
            public static var isShowContentInWebView: Bool { Preferences.shared.configuration.isShowContentInWebView }
            
            /// If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with an active link.
            public static var isParseHTMLWithYouTubePreviews: Bool { Preferences.shared.configuration.isParseHTMLWithYouTubePreviews }
            
        }
        
    }
    
}
