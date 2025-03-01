import SwiftUI
import ApricotNavigation
import NukeUI

struct PostView<ContentUnavailable: View>: View {
    
    @State var viewModel: PostViewModel
    @Binding var tagName: String?
    @Binding var categoryName: String?
    
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    let contentUnavailableView: () -> ContentUnavailable
    
    @Environment(Router.self) private var router
    @State private var nextPostID: Int?
    @State private var alertMessage: String?
    @State private var isUnavailable: Bool = false
    
    @State private var scrollViewHeight: CGFloat = 0
    @State private var proportion: CGFloat = 0
    
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
        ZStack(alignment: .center) {
            ScrollView {
                VStack {
                    headerView()
                        .opacity(viewModel.isShowContent ? 1 : 0)
                        .visualEffect { content, proxy in
                            let frame = proxy.frame(in: .scrollView(axis: .vertical))
                            let distance = min(0, frame.minY)
                            
                            return content
                                .scaleEffect(1 - distance / 1200)
                                .offset(y: -distance / 1.6)
                                .blur(radius: -distance / 30)
                        }
                    
                    content()
                }
                .background(
                    GeometryReader { geo in
                        let scrollLength = geo.size.height - scrollViewHeight
                        let rawProportion = -geo.frame(in: .named("scroll")).minY / scrollLength
                        let proportion = min(max(rawProportion, 0), 1)
                        
                        Color.clear
                            .preference(
                                key: ScrollProportion.self,
                                value: proportion
                            )
                            .onPreferenceChange(ScrollProportion.self) { proportion in
                                Task { @MainActor in
                                    self.proportion = proportion
                                }
                            }
                    }
                )
            }
            .scrollClipDisabled()
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        scrollViewHeight = geo.size.height
                    }
                }
            )
            .coordinateSpace(name: "scroll")
            .alert(isPresented: $alertMessage.boolValue()) {
                Alert(title: Text(alertMessage ?? ""))
            }
            .alert(isPresented: $viewModel.error.boolValue()) {
                Alert(title: Text(viewModel.error?.localizedDescription ?? ""))
            }
            .toolbarBackground(configuration.backgroundColor, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    ProgressIndicator(.small)
                        .opacity(viewModel.isLoading ? 1 : 0)
                    
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
                
                ToolbarItem(placement: .principal) {
                    ProgressView(value: proportion, total: 1)
                        .frame(width: 111)
                        .padding()
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
            if viewModel.isInitialLoading {
                ProgressIndicator(.large)
                    .padding(.top, 150)
            }
        }
        .toolbarRole(.editor)
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
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(configuration.backgroundColor)
                        .blur(radius: 50)
                }
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
        }
    }
    
}

#Preview {
    SwiftPresso.View.default()
}

struct ScrollReadVStackModifier: ViewModifier {
     
    @Binding var scrollViewHeight: CGFloat
    @Binding var proportion: CGFloat
    var proportionName: String
    
    func body(content: Content) -> some View {
        
        content
            .background(
                GeometryReader { geo in
                    let scrollLength = geo.size.height - scrollViewHeight
                    let rawProportion = -geo.frame(in: .named(proportionName)).minY / scrollLength
                    let proportion = min(max(rawProportion, 0), 1)
                    
                    Color.clear
                        .preference(
                            key: ScrollProportion.self,
                            value: proportion
                        )
                        .onPreferenceChange(ScrollProportion.self) { proportion in
                            Task { @MainActor in
                                self.proportion = proportion
                            }
                        }
                }
            )
        
    }
    
}

struct ScrollReadScrollViewModifier: ViewModifier {
     
    @Binding var scrollViewHeight: CGFloat
    var proportionName: String
    
    func body(content: Content) -> some View {
        
        content
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        scrollViewHeight = geo.size.height
                    }
                }
            )
            .coordinateSpace(name: proportionName)
        
    }
    
}

struct ScrollProportion: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
