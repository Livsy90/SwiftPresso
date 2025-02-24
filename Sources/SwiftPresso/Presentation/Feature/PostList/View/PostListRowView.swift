import SwiftUI
import ApricotNavigation
import NukeUI
import Nuke

struct PostListRowView<Placeholder: View>: View {
    
    let post: PostModel
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    @Environment(Router.self) private var router
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        HStack {
            if let imgURL = post.imgURL {
                image(url: imgURL)
            }
            
            VStack(alignment: .leading) {
                rowBody
                Spacer()
                if let date = post.date {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundStyle(Preferences.accentColor.opacity(0.7))
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            
            if post.isPasswordProtected {
                VStack {
                    passwordProtectedView
                        .padding(.bottom, 12)
                    Spacer()
                }
                .frame(width: 21)
                .padding(.horizontal)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Preferences.accentColor)
                .opacity(0.15)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 80)
        .environment(\.configuration, configuration)
        .readSize($size)
    }
    
    @ViewBuilder
    private var rowBody: some View {
        if configuration.isShowContentInWebView, let link = post.link {
            LinkView(
                url: link,
                title: post.title,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        } else {
            Button {
                router.navigate(to: Destination.postDetails(post: post))
            } label: {
                Text(post.title)
                    .font(configuration.postListFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(configuration.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var passwordProtectedView: some View {
        VStack {
            HStack {
                Spacer()
                Preferences.passwordProtectedIcon.image
                    .font(.system(size: 13))
                    .foregroundStyle(Preferences.accentColor)
                    .padding(8)
                    .background {
                        Circle()
                            .fill(.ultraThinMaterial)
                    }
                    .padding(8)
            }
            Spacer()
        }
    }
    
    private func image(url: URL) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
                    .clippedRectangle(size: size)
            } else if state.error != nil {
                Image(systemName: "wifi.exclamationmark")
                    .clippedRectangle(size: size)
            } else {
                ShimmerView()
                    .clippedRectangle(size: size)
            }
        }
        .clippedRectangle(size: size)
    }
    
}

private extension View {
    func clippedRectangle(size: CGSize) -> some View {
        self
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .frame(width: size.width / 3)
    }
}

#Preview {
    SwiftPresso.configure(
        host: "hairify.ru",
        isShowContentInWebView: false
    )
    return SwiftPresso.View.postList()
}
