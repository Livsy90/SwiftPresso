import SwiftUI

struct ShimmerPlacehodler: View {
    
    let backgroundColor: Color
    
    var body: some View {
        ScrollView {
            ForEach(1...100, id: \.self) { _ in
                ShimmerView()
                     .cornerRadius(5)
                     .frame(height: 80)
                     .padding(.vertical, 20)
                     .padding(.horizontal, 12)
            }
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
    
}

private struct ShimmerView: View {
    
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
