import SwiftUI

struct LinkView<Placeholder: View>: View {
    
    let url: URL
    let title: String
    let webViewBackgroundColor: Color
    let interfaceColor: Color
    let textColor: Color
    let font: Font
    
    
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    var body: some View {
        ZStack {
            Link("", destination: url)
            Text(title)
                .font(font)
                .fontWeight(.semibold)
                .foregroundStyle(textColor)
        }
        .webViewLinkRow(
            backgroundColor: webViewBackgroundColor,
            interfaceColor: interfaceColor,
            onTag: onTag,
            onCategory: onCategory,
            placeholder: placeholder
        )
    }
    
}
