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
            .frame(height: viewModel.size.height)
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
    let post = PostModel(
        id: 1,
        date: .now,
        title: "Title",
        excerpt: "",
        imgURL: nil,
        link: URL(string: "https://livsycode.com/"),
        content: "Text",
        author: 0,
        tags: []
    )
    
    return PostView(
        viewModel: .init(post: post, size: UIScreen.main.bounds.size),
        backgroundColor: SwiftPresso.Configuration.backgroundColor,
        textColor: SwiftPresso.Configuration.textColor
    )
    .environment(Router())
}
