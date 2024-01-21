import UIKit

public struct WPPostParts: Identifiable {
    public var id = UUID().uuidString
    public var image: UIImage?
    public var url: URL?
    public var text: NSAttributedString?
    
    public var hasText: Bool {
        !(text?.string.filter({ $0.isWhitespace}).isEmpty ?? true)
    }
}
