import SwiftUI

struct SPLinkView<Placehodler: View>: View {
    
    let url: URL
    let title: String
    let webViewBackgroundColor: Color
    let accentColor: Color
    
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placehodler
    
    var body: some View {
        ZStack {
            Link("", destination: url)
            Text(title)
                .font(.system(size: 22, weight: .semibold))
        }
        .webViewLinkRow(
            backgroundColor: webViewBackgroundColor,
            accentColor: accentColor,
            onTag: onTag,
            onCategory: onCategory,
            placeholder: placeholder
        )
    }
    
}
