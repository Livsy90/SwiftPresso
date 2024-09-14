import SwiftUI

extension SwiftPresso {
    
    /// View factory methods.
    public enum View {
        
        public static func postList(_ configuration: SwiftPressoSettings) -> some SwiftUI.View {
            Configuration.configure(with: configuration)
            return PostListCoordinator(configuration: configuration, placeholder: nil)
        }
        
        public static func postList<Placeholder: SwiftUI.View>(
            _ configuration: SwiftPressoSettings,
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            Configuration.configure(with: configuration)
            return PostListCoordinator(configuration: configuration, placeholder: placeholder)
        }
        
    }
    
}
