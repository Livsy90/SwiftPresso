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
                .readSize { newValue in
                    size = newValue
                }
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .postDetails(let post):
                        PostView(
                            viewModel: .init(post: post, width: size.width),
                            backgroundColor: configuration.backgroundColor,
                            textColor: configuration.textColor
                        )
                    }
                }
                .accentColor(configuration.interfaceColor)
                .tint(configuration.interfaceColor)
                .environment(router)
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
    
}

extension PostListCoordinator where Placeholder == EmptyView {
    init(configuration: SwiftPressoSettings, placeholder: (() -> Placeholder)?) {
        self.configuration = configuration
        self.placeholder = placeholder
    }
}

// TODO: Remove after Xcode update
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
