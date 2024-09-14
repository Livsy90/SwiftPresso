import ApricotNavigation
import SwiftUI

enum Destination: Hashable {
    case postDetails(post: PostModel)
}

struct PostListCoordinator<Placeholder: View>: View {
    
    let configuration: SwiftPressoSettings
    let placeholder: (() -> Placeholder)?
    @State private var router: Router = .init()
    @State private var size: CGSize = .zero
    
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            postList()
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .postDetails(let post):
                        PostView(
                            viewModel: .init(post: post, width: size.width),
                            backgroundColor: configuration.backgroundColor,
                            textColor: configuration.textColor,
                            placeholder: {
                                placeholderView()
                            }
                        )
                    }
                }
        }
        .accentColor(configuration.interfaceColor)
        .tint(configuration.interfaceColor)
        .environment(router)
        .readSize { size in
            self.size = size
        }
    }
    
    @ViewBuilder
    private func postList() -> some View {
        if let placeholder {
            SwiftPresso.View._postListWithCustomPlaceholder(configuration, placeholder: placeholder)
        } else {
            SwiftPresso.View._postList(configuration)
        }
    }
    
    @ViewBuilder
    private func placeholderView() -> some View {
        if let placeholder {
            placeholder()
        } else {
            ShimmerPlaceholder(backgroundColor: configuration.backgroundColor)
        }
    }
    
}

extension PostListCoordinator where Placeholder == EmptyView {
    init(configuration: SwiftPressoSettings, placeholder: (() -> Placeholder)?) {
        self.configuration = configuration
        self.placeholder = placeholder
    }
}
