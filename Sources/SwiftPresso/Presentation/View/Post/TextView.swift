import SwiftUI

struct TextView: UIViewRepresentable {
    
    @Binding var attributedText: NSAttributedString
    let textStyle: UIFont.TextStyle
    
    func makeUIView(context: Context) -> UITextView {
        let textView = GestureHandlingTextView()
        
        textView.isSelectable = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.attributedText = attributedText
        textView.showsVerticalScrollIndicator = false
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
    }
    
    final class GestureHandlingTextView: UITextView {
        
        var didTappedOnAreaBesidesAttachment: (() -> Void)? = nil
        var didTappedOnAttachment: ((UIImage) -> Void)? = nil
        
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
                if let _ = attributedText?.attribute(
                    NSAttributedString.Key.attachment,
                    at: index,
                    effectiveRange: nil
                ) as? NSTextAttachment {
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
            
            isTouchMoved = false
        }
        
        private func isTapOnAttachment(_ point: CGPoint) -> Bool {
            let range = NSRange(
                location: 0,
                length: attributedText.length
            )
            var found = false
            attributedText.enumerateAttribute(
                .attachment,
                in: range,
                options: []
            ) { (value, effectiveRange, stop) in
                guard let attachment = value as? NSTextAttachment else {
                    return
                }
                
                tappedImage = attachment.image
                let rect = layoutManager.boundingRect(
                    forGlyphRange: effectiveRange,
                    in: textContainer
                )
                if rect.contains(point) {
                    found = true
                    stop.pointee = true
                }
            }
            
            return found
        }
    }
    
}
