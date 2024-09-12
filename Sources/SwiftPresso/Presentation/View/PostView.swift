import SwiftUI

struct PostView: View {
    
    @State var viewModel: PostViewModel
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        TextView(
            attributedText: $viewModel.attributedString,
            textStyle: .callout
        )
        .padding()
        .navigationTitle(viewModel.title)
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .background {
            backgroundColor
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
}

struct TextView: UIViewRepresentable {
    
    @Binding var attributedText: NSAttributedString
    let textStyle: UIFont.TextStyle
    
    func makeUIView(context: Context) -> UITextView {
        let textView = TextViewInternal()
        
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.attributedText = attributedText
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
    }
    
    final class TextViewInternal: UITextView {
        
        var didTappedOnAreaBesidesAttachment: (() -> Void)? = nil
        var didTappedOnAttachment: ((UIImage) -> Void)? = nil
        
        // A single tap won't move.
        private var isTouchMoved = false
        private var tappedImage: UIImage?
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesMoved(touches, with: event)
            
            isTouchMoved = true
        }
        
        override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            
            if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
               tapGestureRecognizer.numberOfTapsRequired == 2 {
                let index = indexOfTap(recognizer: tapGestureRecognizer)
                if let _ = attributedText?.attribute(NSAttributedString.Key.attachment, at: index, effectiveRange: nil) as? NSTextAttachment {
                    
                    return false
                }
            }
            
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if isTapOnAttachment(touches.first!.location(in: self)) {
                guard let image = tappedImage else { return }
                didTappedOnAttachment?(image)
                return
            }
            super.touchesEnded(touches, with: event)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            if !isTouchMoved &&
                !isTapOnAttachment(touches.first!.location(in: self)) &&
                selectedRange.length == 0 {
                didTappedOnAreaBesidesAttachment?()
            }
            
            isTouchMoved = false
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesCancelled(touches, with: event)
            
            // `UITextView` will cancel the touch then starting selection
            
            isTouchMoved = false
        }
        
        private func isTapOnAttachment(_ point: CGPoint) -> Bool {
            let range = NSRange(location: 0, length: attributedText.length)
            var found = false
            attributedText.enumerateAttribute(.attachment, in: range, options: []) { (value, effectiveRange, stop) in
                guard let attachment = value as? NSTextAttachment else {
                    return
                }
                
                tappedImage = attachment.image
                let rect = layoutManager.boundingRect(forGlyphRange: effectiveRange, in: textContainer)
                if rect.contains(point) {
                    found = true
                    stop.pointee = true
                }
            }
            
            return found
        }
    }
    
}

extension UITextView {
    func indexOfTap(recognizer: UITapGestureRecognizer) -> Int {
        var location: CGPoint = recognizer.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        
        let charIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return charIndex
    }
    
}

#Preview {
    let testString = "Text"
    let strung = randomString(length: 9000)
    let post = PostModel(id: 1, date: .now, title: "Title", excerpt: "", imgURL: nil, link: nil, content: strung, author: 0, tags: [])
    return PostView(
        viewModel: .init(post: post, width: 375),
        backgroundColor: SwiftPresso.Configuration.backgroundColor,
        textColor: SwiftPresso.Configuration.textColor
    )
}
func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
