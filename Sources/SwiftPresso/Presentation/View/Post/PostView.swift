import SwiftUI
import ApricotNavigation

struct PostView: View {
    
    @State var viewModel: PostViewModel
    let backgroundColor: Color
    let textColor: Color
    
    @Environment(Router.self) private var router
    @State private var nextPostID: Int?
    @State private var alertMessage: String?
    
    var body: some View {
        ScrollView {
            TextView(
                attributedText: $viewModel.attributedString,
                postID: $nextPostID,
                textStyle: .callout
            )
            .padding([.horizontal, .bottom])
            .frame(width: viewModel.size.width ,height: viewModel.size.height)
        }
        .readSize { size in
            viewModel.size = size
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .toolbar {
            if let url = viewModel.url {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                    }
                }
            }
        }
        .background {
            backgroundColor
                .ignoresSafeArea()
        }
        .overlay {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .frame(width: 80, height: 80)
                
                ProgressView()
                    .controlSize(.large)
            }
            .opacity(viewModel.isLoading ? 1 : 0)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: nextPostID) { _, newValue in
            guard let newValue else { return }
            Task {
                do {
                    let post = try await viewModel.post(with: newValue)
                    nextPostID = nil
                    router.navigate(to: Destination.postDetails(post: post))
                } catch {
                    nextPostID = nil
                    alertMessage = error.localizedDescription
                }
            }
        }
    }
    
}

#Preview {
    let text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
    let post = PostModel(
        id: 1,
        date: .now,
        title: "Title",
        excerpt: "",
        imgURL: nil,
        link: URL(string: "https://livsycode.com/"),
        content: text,
        author: 0,
        tags: []
    )
    
    return PostView(
        viewModel: .init(post: post),
        backgroundColor: SwiftPresso.Configuration.backgroundColor,
        textColor: SwiftPresso.Configuration.textColor
    )
    .environment(Router())
}
