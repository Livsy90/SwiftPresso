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
        
        let modifiedFont = formatStringWithYTVideo(
            text: htmlText,
            width: width
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
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        attributedString.addAttributes(
            attributedStringColor,
            range: NSMakeRange(0, attributedString.length)
        )
        
        return attributedString
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
    
}
