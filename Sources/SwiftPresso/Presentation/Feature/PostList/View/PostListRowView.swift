import SwiftUI
import ApricotNavigation

struct PostListRowView<Placeholder: View>: View {
    
    let post: PostModel
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    @Environment(Router.self) private var router
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Preferences.accentColor)
                .opacity(0.15)
                .overlay {
                    if post.isPasswordProtected {
                        VStack {
                            HStack {
                                Spacer()
                                Preferences.passwordProtectedIcon.image
                                    .font(.footnote)
                                    .foregroundStyle(Preferences.accentColor)
                                    .padding(16)
                            }
                            Spacer()
                        }
                    }
                }
            VStack {
                rowBody
                if let date = post.date {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(Preferences.accentColor)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 80)
        .environment(\.configuration, configuration)
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
    
}
