import SwiftUI

struct ProgressIndicator: View {
    
    private let controlSize: ControlSize
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    private var sizeValue: CGFloat {
        switch controlSize {
        case .mini: 20
        case .small: 30
        case .regular: 50
        case .large: 100
        case .extraLarge: 150
        @unknown default: 100
        }
    }
    
    init(_ controlSize: ControlSize) {
        self.controlSize = controlSize
    }
    
    var body: some View {
        loadingIndicator()
    }
    
    private func loadingIndicator() -> some View {
        Image(systemName: "ellipsis")
            .symbolEffect(.variableColor, options: .repeat(.continuous))
            .font(.system(size: sizeValue))
            .fontWeight(.heavy)
            .foregroundStyle(configuration.textColor)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
    
}

#Preview {
    ProgressIndicator(.large)
}
