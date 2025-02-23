import SwiftUI

struct LinkView<Placeholder: View>: View {
    
    let url: URL
    let title: String
    
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    var body: some View {
        ZStack {
            Link("", destination: url)
            Text(title)
                .font(Font(configuration.postBodyFont))
                .fontWeight(.semibold)
                .foregroundStyle(configuration.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .webViewLinkRow(
            onTag: onTag,
            onCategory: onCategory,
            placeholder: placeholder
        )
    }
    
}
