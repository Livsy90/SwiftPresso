import Foundation
import SwiftUI

public extension SwiftPresso {
    
    /// SwiftPresso configuration.
    enum Configuration {
        
        public enum API {
            
            /// API host.
            public static var host: String { Preferences.host }
            
            /// Posts per page in the post list request.
            public static var postsPerPage: Int { Preferences.postsPerPage }
            
            /// API HTTP scheme.
            public static var httpScheme: HTTPScheme { Preferences.httpScheme }
            
            /// API Tag path component.
            public static var tagPathComponent: String { Preferences.tagPathComponent }
            
            /// API Category path component.
            public static var categoryPathComponent: String { Preferences.categoryPathComponent }
            
        }
        
        public enum UI {
            
            /// Remove web page's header and footer.
            public static var isExcludeWebHeaderAndFooter: Bool { Preferences.isExcludeWebHeaderAndFooter }
            
            /// Post list and post view background color.
            public static var backgroundColor: Color { Preferences.backgroundColor }
            
            /// Post list font.
            public static var postListFont: Font { Preferences.postListFont }
            
            /// Post body font.
            public static var postBodyFont: UIFont { Preferences.postBodyFont }
            
            /// Post title font.
            public static var postTitleFont: Font { Preferences.postTitleFont }
            
            /// Post list and post view interface color.
            public static var accentColor: Color { Preferences.accentColor }
            
            /// Post list and post view text color.
            public static var textColor: Color { Preferences.textColor }
            
            /// Determines the visibility of the page menu.
            public static var isShowPageMenu: Bool { Preferences.isShowPageMenu }
            
            /// Post featured image visibility.
            public static var isShowFeaturedImage: Bool { Preferences.isShowFeaturedImage }
            
            /// Determines the visibility of the tag menu.
            public static var isShowTagMenu: Bool { Preferences.isShowTagMenu }
            
            /// Determines the visibility of the category menu.
            public static var isShowCategoryMenu: Bool { Preferences.isShowCategoryMenu }
            
            /// The icon for the navigation bar button that restores the interface to its default state.
            public static var homeIcon: Image { Preferences.homeIcon }
            
            /// Determines the title of the page menu.
            public static var pageMenuTitle: String { Preferences.pageMenuTitle }
            
            /// Determines the title of the tag menu.
            public static var tagMenuTitle: String { Preferences.tagMenuTitle }
            
            /// Determines the title of the category menu.
            public static var categoryMenuTitle: String { Preferences.categoryMenuTitle }
            
            /// Navigation title for default state.
            public static var homeTitle: String { Preferences.homeTitle }
            
            /// Navigation title for search state.
            public static var searchTitle: String { Preferences.searchTitle }
                        
            /// Menu text color.
            public static var menuTextColor: Color { Preferences.menuTextColor }
            
            /// To expand menu items by default.
            public static var isMenuExpanded: Bool { Preferences.isMenuExpanded }
            
            /// Using WKWebView as post view.
            public static var isShowContentInWebView: Bool { Preferences.isShowContentInWebView }
            
            /// If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with an active link.
            public static var isParseHTMLWithYouTubePreviews: Bool { Preferences.isParseHTMLWithYouTubePreviews }
            
        }
        
    }
    
}
