import SwiftUI

extension View {
    
    func webViewLinkRow(
        backgroundColor: Color,
        interfaceColor: Color,
        onTag: @escaping (String) -> Void,
        onCategory: @escaping (String) -> Void,
        placeholder: @escaping () -> some View
    ) -> some View {
        
        modifier(
            WebViewLinkModifier(
                backgroundColor: backgroundColor,
                interfaceColor: interfaceColor,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        )
    }
    
    func webView(
        url: Binding<URL?>,
        backgroundColor: Color,
        interfaceColor: Color,
        onTag: @escaping (String) -> Void,
        onCategory: @escaping (String) -> Void,
        placeholder: @escaping () -> some View
    ) -> some View {
        
        modifier(
            WebViewModifier(
                urlToOpen: url,
                backgroundColor: backgroundColor,
                interfaceColor: interfaceColor,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        )
    }
    
}

private struct WebViewModifier<Placeholder: View>: ViewModifier {
    
    @Binding var urlToOpen: URL?
    let backgroundColor: Color
    let interfaceColor: Color
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    @State private var isLoading = true
    @State private var isGoBack = false
    @State private var isGoForward = false
    @State private var isCanGoBack = false
    @State private var isCanGoForward = false
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(
                isPresented: $urlToOpen.boolValue(),
                onDismiss: {
                    urlToOpen = nil
                },
                content: {
                    WebViewWrapperView(
                        backgroundColor: backgroundColor,
                        interfaceColor: interfaceColor,
                        urlToOpen: $urlToOpen,
                        isLoading: $isLoading,
                        isGoBack: $isGoBack,
                        isGoForward: $isGoForward,
                        isCanGoBack: $isCanGoBack,
                        isCanGoForward: $isCanGoForward,
                        placeHolder: placeholder,
                        onTag: onTag,
                        onCategory: onCategory
                    )
                })
    }
    
}

private struct WebViewLinkModifier<Placeholder: View>: ViewModifier {
    
    let backgroundColor: Color
    let interfaceColor: Color
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    @State private var urlToOpen: URL?
    @State private var isLoading = true
    @State private var isGoBack = false
    @State private var isGoForward = false
    @State private var isCanGoBack = false
    @State private var isCanGoForward = false
    
    func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                urlToOpen = url
                return .handled
            })
            .fullScreenCover(
                isPresented: $urlToOpen.boolValue(),
                onDismiss: {
                    urlToOpen = nil
                },
                content: {
                    WebViewWrapperView(
                        backgroundColor: backgroundColor,
                        interfaceColor: interfaceColor,
                        urlToOpen: $urlToOpen,
                        isLoading: $isLoading,
                        isGoBack: $isGoBack,
                        isGoForward: $isGoForward,
                        isCanGoBack: $isCanGoBack,
                        isCanGoForward: $isCanGoForward,
                        placeHolder: placeholder,
                        onTag: onTag,
                        onCategory: onCategory
                    )
                })
    }
    
}
