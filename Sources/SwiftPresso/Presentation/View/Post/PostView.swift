import SwiftUI
import ApricotNavigation

struct PostView<Placeholder: View>: View {
    
    @State var viewModel: PostViewModel
    @Binding var tagName: String?
    @Binding var categoryName: String?
    
    let backgroundColor: Color
    let textColor: Color
    let placeholder: () -> Placeholder
    
    @Environment(Router.self) private var router
    @State private var nextPostID: Int?
    @State private var alertMessage: String?
    
    var body: some View {
        ScrollView {
            if viewModel.isInitialLoading {
                placeholder()
            }
            
            HStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(textColor)
                    .textSelection(.enabled)
                Spacer()
            }
            .padding()
            .opacity(viewModel.isShowContent ? 1 : 0)
            
            Divider()
                .padding()
                .opacity(viewModel.isShowContent ? 1 : 0)
            
            if let date = viewModel.date {
                HStack {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(textColor)
                    Spacer()
                }
                .padding([.bottom, .horizontal])
                .opacity(viewModel.isShowContent ? 1 : 0)
            }
            
            TextView(
                "", 
                postID: $nextPostID,
                tagName: $tagName,
                categoryName: $categoryName,
                attributedString: $viewModel.attributedString,
                shouldEditInRange: nil,
                onEditingChanged: nil,
                onCommit: nil
            )
            .opacity(viewModel.isShowContent ? 1 : 0)
            .padding(.horizontal)
        }
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                ProgressView()
                    .opacity(viewModel.isLoading || viewModel.isInitialLoading ? 1 : 0)
                
                if let url = viewModel.url {
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
    let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
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
        viewModel: .init(post: post, width: 375),
        tagName: .constant(nil),
        categoryName: .constant(nil),
        backgroundColor: SwiftPresso.Configuration.backgroundColor,
        textColor: SwiftPresso.Configuration.textColor,
        placeholder: {
            ShimmerPlaceholder(backgroundColor: .clear)
        }
    )
    .environment(Router())
}
