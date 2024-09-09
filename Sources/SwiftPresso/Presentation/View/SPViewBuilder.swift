import SwiftUI

public enum SPViewBuilder {
        
    public static func postList<Placeholder: View>(
        configuration: SPConfigurator.Configuration,
        placeholder: @escaping () -> Placeholder
    ) -> some View {
        
        SPConfigurator.shared.configuration = configuration
        
        return SPPostListView(
            backgroundColor: configuration.backgroundColor,
            accentColor: configuration.accentColor,
            textColor: configuration.textColor,
            homeIcon: configuration.homeIcon,
            tagIcon: configuration.tagIcon,
            pageIcon: configuration.pageIcon,
            categoryIcon: configuration.categoryIcon,
            isShowPageMenu: configuration.isShowPageMenu,
            isShowTagMenu: configuration.isShowTagMenu,
            isShowCategoryMenu: configuration.isShowCategoryMenu,
            postPerPage: configuration.postsPerPage,
            loadingPlaceholder: placeholder
        )
    }
    
    public static func shimmerPlaceholder(backgroundColor: Color) -> some View {
        SPShimmerPlacehodler(backgroundColor: backgroundColor)
    }
    
}
