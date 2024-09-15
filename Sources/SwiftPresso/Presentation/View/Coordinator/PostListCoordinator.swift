import ApricotNavigation
import SwiftUI

enum Destination: Hashable {
    case postDetails(post: PostModel)
}

struct PostListCoordinator<Placeholder: View>: View {
    
    private let configuration: Preferences.Configuration
    private let placeholder: (() -> Placeholder)?
    @State private var router: Router = .init()
    @State private var size: CGSize = .zero
    @State private var tagName: String? = nil
    @State private var categoryName: String? = nil
    
    init(
        configuration: Preferences.Configuration,
        placeholder: (() -> Placeholder)?
    ) {
        self.configuration = configuration
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
        .accentColor(configuration.interfaceColor)
        .tint(configuration.interfaceColor)
        .environment(router)
        .readSize { size in
            self.size = size
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
    
    init(
        configuration: Preferences.Configuration,
        placeholder: (() -> Placeholder)?
    ) {
        self.configuration = configuration
        self.placeholder = placeholder
    }
    
}

private extension PostListCoordinator {
    
    func postListView() -> some View {
        PostListView(
            viewModel: .init(postPerPage: configuration.postsPerPage),
            externalTagName: $tagName,
            externalCategoryName: $categoryName,
            backgroundColor: configuration.backgroundColor,
            interfaceColor: configuration.interfaceColor,
            textColor: configuration.textColor,
            menuBackgroundColor: configuration.menuBackgroundColor,
            menuTextColor: configuration.menuTextColor,
            homeIcon: configuration.homeIcon,
            isShowContentInWebView: configuration.isShowContentInWebView,
            isShowPageMenu: configuration.isShowPageMenu,
            isShowTagMenu: configuration.isShowTagMenu,
            isShowCategoryMenu: configuration.isShowCategoryMenu,
            isMenuExpanded: configuration.isMenuExpanded,
            pageMenuTitle: configuration.pageMenuTitle,
            tagMenuTitle: configuration.tagMenuTitle,
            categoryMenuTitle: configuration.categoryMenuTitle
        ) {
            placeholderView()
        }
    }
    
    func postView(_ post: PostModel) -> some View {
        PostView(
            viewModel: .init(post: post, width: size.width),
            tagName: $tagName,
            categoryName: $categoryName,
            backgroundColor: configuration.backgroundColor,
            textColor: configuration.textColor
        ) {
            placeholderView()
        }
    }
    
    @ViewBuilder
    func placeholderView() -> some View {
        if let placeholder {
            placeholder()
        } else {
            ShimmerPlaceholder(backgroundColor: configuration.backgroundColor)
        }
    }
    
}

#Preview {
    SwiftPresso.View.postList("livsycode.com")
}
