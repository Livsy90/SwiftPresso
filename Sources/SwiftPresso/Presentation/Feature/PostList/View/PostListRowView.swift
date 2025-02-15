import SwiftUI
import ApricotNavigation

struct PostListRowView<Placeholder: View>: View {
    
    let post: PostModel
    let isShowContentInWebView: Bool
    let webViewBackgroundColor: Color
    let accentColor: Color
    let textColor: Color
    let font: Font
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    @Environment(Router.self) private var router
    
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
                                    .font(.caption)
                                    .foregroundStyle(Preferences.accentColor)
                                    .padding(8)
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
    }
    
    @ViewBuilder
    private var rowBody: some View {
        if isShowContentInWebView, let link = post.link {
            LinkView(
                url: link,
                title: post.title,
                webViewBackgroundColor: webViewBackgroundColor,
                accentColor: accentColor,
                textColor: textColor,
                font: font,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        } else {
            Button {
                router.navigate(to: Destination.postDetails(post: post))
            } label: {
                Text(post.title)
                    .font(font)
                    .fontWeight(.semibold)
                    .foregroundStyle(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
}
