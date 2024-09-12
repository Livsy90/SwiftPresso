import SwiftUI

struct LinkView<Placehodler: View>: View {
    
    let url: URL
    let title: String
    let webViewBackgroundColor: Color
    let interfaceColor: Color
    let textColor: Color
    
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placehodler
    
    var body: some View {
        ZStack {
            Link("", destination: url)
            Text(title)
                .font(.system(size: 22, weight: .semibold))
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
