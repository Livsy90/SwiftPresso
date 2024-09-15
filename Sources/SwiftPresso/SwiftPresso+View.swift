import SwiftUI

public extension SwiftPresso {
    
    /// View factory methods.
    enum View {
        
        public static func postList(_ configuration: Preferences.Configuration) -> some SwiftUI.View {
            Configuration.configure(with: configuration)
            return PostListCoordinator(
                configuration: configuration,
                placeholder: nil
            )
        }
        
        public static func postList<Placeholder: SwiftUI.View>(
            _ configuration: Preferences.Configuration,
            placeholder: @escaping () -> Placeholder
        ) -> some SwiftUI.View {
            Configuration.configure(with: configuration)
            return PostListCoordinator(
                configuration: configuration,
                placeholder: placeholder
            )
        }
        
    }
    
}
