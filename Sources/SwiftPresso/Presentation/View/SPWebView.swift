import SwiftUI
import WebKit

struct SPWebView: UIViewRepresentable {
    
    let url: URL
    @Binding var isLoading: Bool
    @Binding var isGoBack: Bool
    @Binding var isGoForward: Bool
    @Binding var isCanGoBack: Bool
    @Binding var isCanGoForward: Bool
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let contentController = WKUserContentController()
        
        if SPPreferences.shared.configuration.isExcludeWebHeaderAndFooter {
            let script = """
            var style = document.createElement('style');
            style.innerHTML = 'header {display: none;} footer {display: none;}';
            document.head.appendChild(style);
            """
            let scriptInjection = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            contentController.addUserScript(scriptInjection)
        }
        
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        configuration.userContentController = contentController
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        withAnimation {
            isCanGoBack = uiView.canGoBack
            isCanGoForward = uiView.canGoForward
        }
        
        if isGoBack {
            uiView.goBack()
            isGoBack.toggle()
        }
        
        if isGoForward {
            uiView.goForward()
            isGoForward.toggle()
        }
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        
        private let parent: SPWebView
        
        init(_ parent: SPWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            withAnimation {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            withAnimation {
                self.parent.isLoading = false
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let url = navigationAction.request.url, url.scheme?.lowercased() == "mailto" {
                decisionHandler(.cancel)
                UIApplication.shared.open(url)
                return
            }
            
            guard let url = navigationAction.request.url, let host = url.host() else {
                return
            }
            
            let components = url.pathComponents
            
            if components.contains("tag"), let tagName = components.last {
                parent.onTag(tagName)
            }
            
            if components.contains("category"), let categoryName = components.last {
                parent.onCategory(categoryName)
            }
            
            if host != SPPreferences.shared.configuration.host {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
        
    }
    
}
