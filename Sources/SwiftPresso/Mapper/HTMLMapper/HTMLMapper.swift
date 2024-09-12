import Foundation
import UIKit

struct HTMLMapper: HTMLMapperProtocol {
    
    /// Create an ``NSMutableAttributedString`` value from an HTML string. If the HTML text contains a link to a YouTube video, it will display as a preview of that video with a clickable link.
    /// - Parameters:
    ///   - htmlText: HTML text.
    ///   - width: Width of the view where this text will be presented.
    /// - Returns: An ``NSMutableAttributedString`` value.
    func attributedStringFrom(
        htmlText: String,
        width: CGFloat
    ) -> NSMutableAttributedString {
        
        guard
            let data = htmlText.data(
                using: .unicode,
                allowLossyConversion: true
            ),
            let attributedString = try? NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            ) else {
            assert(
                false,
                "SwiftPresso HTMLMapper: attributedStringFrom(htmlText: \(htmlText)"
            )
            return .init()
        }
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        attributedString.addAttributes(
            attributedStringColor,
            range: NSMakeRange(0, attributedString.length)
        )
        
        return attributedString
    }
    
}
