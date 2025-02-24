import SwiftUI
import ApricotNavigation
import NukeUI

struct PostView<Placeholder: View, ContentUnavailable: View>: View {
    
    @State var viewModel: PostViewModel
    @Binding var tagName: String?
    @Binding var categoryName: String?
    
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    let placeholder: () -> Placeholder
    let contentUnavailableView: () -> ContentUnavailable
    
    @Environment(Router.self) private var router
    @State private var nextPostID: Int?
    @State private var alertMessage: String?
    @State private var isUnavailable: Bool = false
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            if viewModel.isInitialLoading {
                placeholder()
            }
            
            if configuration.isShowFeaturedImage, let featuredImageURL = viewModel.featuredImageURL {
                image(url: featuredImageURL)
                .frame(maxWidth: .infinity)
                .opacity(viewModel.isShowContent ? 1 : 0)
                .frame(height: 300 + max(0, -offset))
                .clipped()
                .offset(y: -(max(0, offset)))
            }
            
            HStack {
                Text(viewModel.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(configuration.textColor)
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
                        .foregroundStyle(configuration.textColor)
                    Spacer()
                }
                .padding([.bottom, .horizontal])
                .opacity(viewModel.isShowContent ? 1 : 0)
            }
            
            if isUnavailable {
                contentUnavailableView()
            } else {
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
        }
        .onScrollGeometryChange(for: CGFloat.self, of: { geo in geo.contentOffset.y + geo.contentInsets.top }, action: { new, _ in
            offset = new
        })
        .alert(isPresented: $alertMessage.boolValue()) {
            Alert(title: Text(alertMessage ?? ""))
        }
        .alert(isPresented: $viewModel.error.boolValue()) {
            Alert(title: Text(viewModel.error?.localizedDescription ?? ""))
        }
        .toolbarBackground(configuration.backgroundColor, for: .navigationBar)
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
            configuration.backgroundColor
                .ignoresSafeArea()
        }
        .onAppear {
            Task {
                await viewModel.onAppear {
                    isUnavailable = true
                }
            }
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
    
    private func image(url: URL) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
            } else if state.error != nil {
                Image(systemName: "wifi.exclamationmark")
            } else {
                ShimmerView()
            }
        }
    }
    
}

#Preview {
    SwiftPresso.configure(
        host: "hairify.ru",
        isShowContentInWebView: false
    )
    return SwiftPresso.View.postList()
}
