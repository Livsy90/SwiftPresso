import Foundation
import SwiftUI

struct HTMLMapper: HTMLMapperProtocol {
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    /// Create an ``NSMutableAttributedString`` value from an HTML string. If the HTML text contains a link to a YouTube video, it will display as a preview of that video with a link.
    /// - Parameters:
    ///   - htmlText: HTML text.
    ///   - width: Width of the view where this text will be presented.
    /// - Returns: An ``NSMutableAttributedString`` value.
    func attributedStringFrom(
        htmlText: String,
        width: CGFloat
    ) -> NSMutableAttributedString {
        let modifiedFont = String(
            format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.preferredFont(forTextStyle: .callout).pointSize)\">%@</span>",
            formatStringWithYTVideo(text: htmlText, width: width)
        )
        
        guard
            let data = modifiedFont.data(
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
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: UIColor( SwiftPresso.Configuration.textColor)]
        attributedString.addAttributes(
            attributedStringColor,
            range: NSMakeRange(0, attributedString.length)
        )
        
        return configured(attrStr: attributedString)
    }
    
    private func formatStringWithYTVideo(
        text: String,
        width: CGFloat
    ) -> String {
        let iframeTexts = matches(for: ".*iframe.*", in: text)
        var newText = text
        
        if !iframeTexts.isEmpty {
            iframeTexts.forEach { iframeText in
                let iframeId = matches(
                    for: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)",
                    in: iframeText
                )
                
                if !iframeId.isEmpty {
                    let imgString = """
                    <a href='https://www.youtube.com/watch?v=\(iframeId[0])'><img src="https://img.youtube.com/vi/\(iframeId[0])/maxresdefault.jpg" alt="" width="\(width)"/></a>
                    """
                    newText = newText.replacingOccurrences(
                        of: iframeText,
                        with: imgString
                    )
                }
            }
        }
        
        return newText
    }
    
    private func matches(
        for regex: String,
        in text: String
    ) -> [String] {
        do {
            let regex = try NSRegularExpression(
                pattern: regex,
                options: .caseInsensitive
            )
            let nsString = text as NSString
            let results = regex.matches(
                in: text,
                range: NSRange(location: 0, length: nsString.length)
            )
            return results.map { nsString.substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    private func configured(attrStr: NSMutableAttributedString) -> NSMutableAttributedString {
        attrStr.enumerateAttribute(
            NSAttributedString.Key.attachment,
            in: NSMakeRange(0, attrStr.length), options: .init(rawValue: 0),
            using: { value, range, stop in
                
            if let attachement = value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                let newImage = image.resize(scaledToWidth: screenWidth - 44)
                let newAttribut = NSTextAttachment()
                
                newAttribut.image = newImage
                attrStr.addAttribute(NSAttributedString.Key.attachment, value: newAttribut, range: range)
            }
        })
        return attrStr
    }
    
}
