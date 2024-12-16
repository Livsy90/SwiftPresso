import UIKit

extension UITextView {
    
    func indexOfTap(recognizer: UITapGestureRecognizer) -> Int {
        var location: CGPoint = recognizer.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        
        let charIndex = layoutManager.characterIndex(
            for: location,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        return charIndex
    }
    
}
