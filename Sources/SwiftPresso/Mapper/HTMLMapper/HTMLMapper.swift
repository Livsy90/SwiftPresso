import SwiftUI

struct HTMLMapper: HTMLMapperProtocol {
        
    /// Create an ``NSMutableAttributedString`` value from an HTML string.
    /// - Parameters:
    ///   - htmlText: HTML text to parse.
    ///   - color: Text color.
    ///   - fontStyle: Text font style.
    ///   - width: Width of images and YouTube previews.
    ///   - isHandleYouTubeVideos:
    /// - Returns: If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with an active link.
    func attributedStringFrom(
        htmlText: String,
        color: UIColor,
        font: Font,
        width: CGFloat,
        isHandleYouTubeVideos: Bool
    ) -> NSMutableAttributedString {
        var text = htmlText
        
        if isHandleYouTubeVideos {
            text = formatStringWithYTVideo(
                text: text,
                width: width
            )
        }
        
        let format = "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(UIFont.preferredFont(from: font).pointSize)\">%@</span>"
        
        let modifiedFontString = String(
            format: format,
            text
        )
        
        guard
            let data = modifiedFontString.data(
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
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: color]
        attributedString.addAttributes(
            attributedStringColor,
            range: NSMakeRange(0, attributedString.length)
        )
        
        return configured(attrStr: attributedString, width: width)
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
    
    private func configured(attrStr: NSMutableAttributedString, width: CGFloat) -> NSMutableAttributedString {
        attrStr.enumerateAttribute(
            NSAttributedString.Key.attachment,
            in: NSMakeRange(0, attrStr.length), options: .init(rawValue: 0),
            using: { value, range, stop in
                
            if let attachement = value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                let newImage = image.resize(scaledToWidth: width)
                let newAttribut = NSTextAttachment()
                
                newAttribut.image = newImage
                attrStr.addAttribute(NSAttributedString.Key.attachment, value: newAttribut, range: range)
            }
        })
        return attrStr
    }
    
}
