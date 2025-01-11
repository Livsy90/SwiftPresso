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
            WebViewLinkModifier(
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
            WebViewModifier(
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

private struct WebViewModifier<Placeholder: View>: ViewModifier {
    
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
                    WebViewWrapperView(
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
                    .gesture(
                        DragGesture().onEnded { event in
                            if event.location.x < 200 && abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
                                if event.translation.width > 0, !isCanGoBack {
                                    urlToOpen = nil
                                }
                            }
                        }
                    )
                })
    }
    
}

private struct WebViewLinkModifier<Placeholder: View>: ViewModifier {
    
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
                    WebViewWrapperView(
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
                    .gesture(
                        DragGesture().onEnded { event in
                            if event.location.x < 200 && abs(event.translation.height) < 50 && abs(event.translation.width) > 50 {
                                if event.translation.width > 0, !isCanGoBack {
                                    urlToOpen = nil
                                }
                            }
                        }
                    )
                })
    }
    
}
