import SwiftUI

struct SPShimmerView: View {
    
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

public struct SPShimmerPlacehodler: View {
    
    public let backgroundColor: Color
    
    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                SPShimmerView()
                     .cornerRadius(5)
                     .frame(height: 60)
                
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 2)
                    .padding(.bottom, 60)
                    .padding(.top, 20)
                
                ForEach(1...100, id: \.self) { _ in
                    SPShimmerView()
                         .cornerRadius(5)
                         .frame(height: 150)
                         .padding(.vertical, 12)
                }
            }
            .padding(22)
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
    
}

public struct SPShimmerHomePlacehodler: View {
    
    public let backgroundColor: Color
    
    public init(backgroundColor: Color) {
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ScrollView {
            ForEach(1...100, id: \.self) { _ in
                SPShimmerView()
                     .cornerRadius(5)
                     .frame(height: 80)
                     .padding(.vertical, 20)
            }
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
    
}