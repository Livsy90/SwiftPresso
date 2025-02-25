import SwiftUI

struct LoadingIndicator: View {
    
    let isPrimary: Bool
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    var body: some View {
        loadingIndicator()
    }
    
    private func loadingIndicator() -> some View {
        Image(systemName: "ellipsis")
            .symbolEffect(.variableColor, options: .repeat(.continuous))
            .font(.system(size: isPrimary ? 100 : 30))
            .fontWeight(.heavy)
            .foregroundStyle(configuration.textColor)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
}

#Preview {
    LoadingIndicator(isPrimary: true)
}
