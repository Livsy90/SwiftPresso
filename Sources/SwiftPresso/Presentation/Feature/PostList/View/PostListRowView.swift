import SwiftUI
import ApricotNavigation

struct PostListRowView<Placeholder: View>: View {
    
    let post: PostModel
    let isShowContentInWebView: Bool
    let webViewBackgroundColor: Color
    let interfaceColor: Color
    let textColor: Color
    let font: Font
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    @Environment(Router.self) private var router
    
    var body: some View {
        if isShowContentInWebView, let link = post.link {
            LinkView(
                url: link,
                title: post.title,
                webViewBackgroundColor: webViewBackgroundColor,
                interfaceColor: interfaceColor,
                textColor: textColor,
                font: font,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
            .padding(.vertical, 8)
        } else {
            Button {
                router.navigate(to: Destination.postDetails(post: post))
            } label: {
                Text(post.title)
                    .padding(.vertical, 8)
                    .font(font)
                    .fontWeight(.semibold)
                    .foregroundStyle(textColor)
            }
        }
    }
    
}
