import ApricotNavigation
import SwiftUI

enum Destination: Hashable {
    case postDetails(post: PostModel)
}

struct PostListCoordinator<Placeholder: View, ContentUnavailable: View>: View {
    
    @Environment(\.configuration) private var configuration: Preferences.Configuration
        
    let placeholder: (() -> Placeholder)
    let postContentUnavailableView: (() -> ContentUnavailable)
    
    @State private var router: Router = .init()
    @State private var size: CGSize = .zero
    @State private var tagName: String? = nil
    @State private var categoryName: String? = nil
    
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
        .accentColor(configuration.accentColor)
        .tint(configuration.accentColor)
        .environment(router)
        .environment(\.configuration, configuration)
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

private extension PostListCoordinator {
    
    func postListView() -> some View {
        PostListView(
            viewModel: .init(postPerPage: configuration.postsPerPage),
            externalTagName: $tagName,
            externalCategoryName: $categoryName) {
                placeholder()
            }
    }
    
    func postView(_ post: PostModel) -> some View {
        PostView(
            viewModel: .init(post: post, width: size.width),
            tagName: $tagName,
            categoryName: $categoryName,
            placeholder: {
                placeholder()
            },
            contentUnavailableView: {
                postContentUnavailableView()
            }
        )
    }
    
}

#Preview {
    SwiftPresso.configure(host: "livsycode.com")
    return SwiftPresso.View.postList()
}
