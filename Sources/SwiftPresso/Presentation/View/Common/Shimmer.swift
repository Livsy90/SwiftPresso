import SwiftUI

struct ShimmerPlaceholder: View {
    
    @Environment(\.configuration) private var configuration: Preferences.Configuration

    var body: some View {
        ScrollView {
            ForEach(1...100, id: \.self) { _ in
                ShimmerView()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(height: 80)
                    .padding(6)
            }
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(configuration.backgroundColor)
    }
    
}

struct ShimmerView: View {
    
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    
    private var gradientColors = [Color.gray.opacity(0.2), Color.white.opacity(0.2), Color.gray.opacity(0.2)]
    
    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                    startPoint = .init(x: 1, y: 1)
                    endPoint = .init(x: 2.2, y: 2.2)
                }
            }
    }
}
