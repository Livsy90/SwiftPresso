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
    
    private var gradientColors: [Color] {
        [
            configuration.backgroundColor.opacity(0),
            configuration.backgroundColor.opacity(0.383),
            configuration.backgroundColor.opacity(0.707),
            configuration.backgroundColor.opacity(0.924),
            configuration.backgroundColor
        ]
    }
    
    var body: some View {
        ScrollView {
            if viewModel.isInitialLoading {
                placeholder()
            }
            
            headerView()
                .opacity(viewModel.isShowContent ? 1 : 0)
                .visualEffect { content, proxy in
                    let frame = proxy.frame(in: .scrollView(axis: .vertical))
                    let distance = min(0, frame.minY)
                    
                    return content
                        .offset(y: -distance / 1.6)
                        .blur(radius: -distance / 30)
                }
            
            content()
        }
        .scrollClipDisabled()
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
    
    @ViewBuilder
    private func headerView() -> some View {
        if configuration.isShowFeaturedImage, let featuredImageURL = viewModel.featuredImageURL {
            headerTitle(featuredImageURL: featuredImageURL)
        } else {
            titleView()
                .padding()
        }
    }
    
    private func headerTitle(featuredImageURL: URL) -> some View {
        ZStack(alignment: .bottomLeading) {
            image(url: featuredImageURL)
                .frame(maxWidth: .infinity)
                .opacity(viewModel.isShowContent ? 1 : 0)
                .mask {
                    VStack(spacing: 0) {
                        Rectangle()
                        
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 150)
                    }
                }
            
            titleView()
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 8)
                }
                .padding(12)
        }
    }
    
    private func titleView() -> some View {
        VStack(spacing: 18) {
            Text(viewModel.title)
                .font(.title)
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .foregroundStyle(configuration.textColor)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .center)
            
            if let date = viewModel.date {
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(configuration.textColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(12)
    }
    
    private func content() -> some View {
        Group {
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
                .padding(.vertical, 16)
            }
        }
        .background {
            configuration.backgroundColor
                .mask {
                    VStack(spacing: 0) {
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 15)
                        
                        Rectangle()
                    }
                }
        }
    }

}

#Preview {
    SwiftPresso.View.default()
}
