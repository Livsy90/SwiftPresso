import SwiftUI

struct WebViewWrapperView<Content: View>: View {
    
    @Binding var urlToOpen: URL?
    @Binding var isLoading: Bool
    @Binding var isGoBack: Bool
    @Binding var isGoForward: Bool
    @Binding var isCanGoBack: Bool
    @Binding var isCanGoForward: Bool
    let placeHolder: () -> Content
    
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if isCanGoBack {
                    Button(action: {
                        isGoBack.toggle()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .fontWeight(.semibold)
                    })
                    .accentColor(configuration.accentColor)
                    .padding(.horizontal)
                    .opacity(isCanGoBack ? 1 : 0)
                    .animation(.default, value: isCanGoBack)
                }
                
                Spacer()
                
                if let urlToOpen {
                    ShareLink(item: urlToOpen) {
                        Image(systemName: "square.and.arrow.up")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                    }
                }
                
                Button {
                    urlToOpen = nil
                } label: {
                    Image(systemName: "xmark")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                }
                .accentColor(configuration.accentColor)
                .padding(.horizontal)
            }
            .frame(minHeight: 44)
            
            ZStack {
                if let urlToOpen {
                    WebView(
                        url: urlToOpen,
                        isLoading: $isLoading,
                        isGoBack: $isGoBack,
                        isGoForward: $isGoForward,
                        isCanGoBack: $isCanGoBack,
                        isCanGoForward: $isCanGoForward,
                        onTag: { tagName in
                            onTag(tagName)
                            self.urlToOpen = nil
                        },
                        onCategory: { categoryName in
                            onCategory(categoryName)
                            self.urlToOpen = nil
                        }
                    )
                    .opacity(isLoading ? 0 : 1)
                    .ignoresSafeArea(edges: .bottom)
                }
                placeHolder()
                    .opacity(isLoading ? 1 : 0)
                    .animation(.easeInOut(duration: isLoading ? 0 : 0.5), value: isLoading)
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
            }
        }
        .background {
            Rectangle()
                .fill(configuration.backgroundColor)
                .ignoresSafeArea()
        }
    }
    
}
