import SwiftUI

extension View {
    
    func webViewLinkRow(
        backgroundColor: Color,
        accentColor: Color,
        onTag: @escaping (String) -> Void,
        onCategory: @escaping (String) -> Void,
        placeholder: @escaping () -> some View
    ) -> some View {
        
        modifier(
            SPWebViewLinkModifier(
                backgroundColor: backgroundColor,
                accentColor: accentColor,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        )
    }
    
    func webView(
        url: Binding<URL?>,
        backgroundColor: Color,
        accentColor: Color,
        onTag: @escaping (String) -> Void,
        onCategory: @escaping (String) -> Void,
        placeholder: @escaping () -> some View
    ) -> some View {
        
        modifier(
            SPWebViewModifier(
                urlToOpen: url,
                backgroundColor: backgroundColor,
                accentColor: accentColor,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        )
    }
    
}

private struct SPWebViewModifier<Placeholder: View>: ViewModifier {
    
    @Binding var urlToOpen: URL?
    let backgroundColor: Color
    let accentColor: Color
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
                    SPWebViewWrapperView(
                        backgroundColor: backgroundColor,
                        accentColor: accentColor,
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

private struct SPWebViewLinkModifier<Placeholder: View>: ViewModifier {
    
    let backgroundColor: Color
    let accentColor: Color
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
                    SPWebViewWrapperView(
                        backgroundColor: backgroundColor,
                        accentColor: accentColor,
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
