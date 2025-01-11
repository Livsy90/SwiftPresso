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
            RoundedRectangle(cornerSize: .init(width: 16, height: 16), style: .continuous)
                .fill(Preferences.accentColor)
                .opacity(0.15)
            rowBody
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
            }
        }
    }
    
}

extension Button {
    var listRowButton: some View {
        buttonStyle(ListRowButtonStyle())
    }
}

private struct ListRowButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        let color: Color = switch configuration.role {
        case .cancel:
            .accentColor.opacity(0.5)
        case .destructive:
            .red
        default:
            .accentColor
        }
        
        let foregroundColor: Color = if configuration.isPressed || !isEnabled {
            color.opacity(0.5)
        } else {
            color
        }
        
        return configuration.label
            .foregroundColor(foregroundColor)
    }
}
