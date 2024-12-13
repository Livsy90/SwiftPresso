import ApricotNavigation
import SwiftUI

enum Destination: Hashable {
    case postDetails(post: PostModel)
}

struct PostListCoordinator<Placeholder: View>: View {
    
    typealias Configuration = SwiftPresso.Configuration
    
    private let placeholder: (() -> Placeholder)?
    @State private var router: Router = .init()
    @State private var size: CGSize = .zero
    @State private var tagName: String? = nil
    @State private var categoryName: String? = nil
    
    init(placeholder: (() -> Placeholder)?) {
        self.placeholder = placeholder
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            postListView()
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .postDetails(let post):
                        postView(post)
                    }
                }
        }
        .accentColor(Configuration.UI.interfaceColor)
        .tint(Configuration.UI.interfaceColor)
        .environment(router)
        .onGeometryChange(for: CGSize.self) { geometry in
            return geometry.size
        } action: { newValue in
            size = newValue
        }
        .onChange(of: tagName) { _, newValue in
            guard newValue != nil else { return }
            router.navigateToRoot()
            tagName = nil
        }
        .onChange(of: categoryName) { _, newValue in
            guard newValue != nil else { return }
            router.navigateToRoot()
            categoryName = nil
        }
    }
    
}

extension PostListCoordinator where Placeholder == EmptyView {
    
    init(placeholder: (() -> Placeholder)?) {
        self.placeholder = placeholder
    }
    
}

private extension PostListCoordinator {
    
    func postListView() -> some View {
        PostListView(
            viewModel: .init(postPerPage: Configuration.API.postsPerPage),
            externalTagName: $tagName,
            externalCategoryName: $categoryName,
            backgroundColor: Configuration.UI.backgroundColor,
            interfaceColor: Configuration.UI.interfaceColor,
            textColor: Configuration.UI.textColor,
            font: Configuration.UI.postListFont,
            menuBackgroundColor: Configuration.UI.menuBackgroundColor,
            menuTextColor: Configuration.UI.menuTextColor,
            homeIcon: Configuration.UI.homeIcon,
            isShowContentInWebView: Configuration.UI.isShowContentInWebView,
            isShowPageMenu: Configuration.UI.isShowPageMenu,
            isShowTagMenu: Configuration.UI.isShowTagMenu,
            isShowCategoryMenu: Configuration.UI.isShowCategoryMenu,
            isMenuExpanded: Configuration.UI.isMenuExpanded,
            pageMenuTitle: Configuration.UI.pageMenuTitle,
            tagMenuTitle: Configuration.UI.tagMenuTitle,
            categoryMenuTitle: Configuration.UI.categoryMenuTitle
        ) {
            placeholderView()
        }
    }
    
    func postView(_ post: PostModel) -> some View {
        PostView(
            viewModel: .init(post: post, width: size.width),
            tagName: $tagName,
            categoryName: $categoryName,
            backgroundColor: Configuration.UI.backgroundColor,
            textColor: Configuration.UI.textColor,
            titleFont: Configuration.UI.postTitleFont,
            isShowFeaturedImage: Configuration.UI.isShowFeaturedImage
        ) {
            placeholderView()
        }
    }
    
    @ViewBuilder
    func placeholderView() -> some View {
        if let placeholder {
            placeholder()
        } else {
            ShimmerPlaceholder(backgroundColor: Configuration.UI.backgroundColor)
        }
    }
    
}

#Preview {
    SwiftPresso.View.postList(host: "livsycode.com")
}
