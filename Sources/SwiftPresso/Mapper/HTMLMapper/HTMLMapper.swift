import Foundation
import UIKit

public struct HTMLMapper: HTMLMapperProtocol {
    
    public init() {}
    
    public func attributedStringFrom(htmlText: String) -> NSMutableAttributedString {
        let modifiedFont = formatStringWithYTVideo(text: htmlText)
        
        guard let data = modifiedFont.data(using: .unicode, allowLossyConversion: true), let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) else {
            assert(false, "HTMLMapper: attributedStringFrom(htmlText: \(htmlText)")
            return .init()
        }
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        attributedString.addAttributes(attributedStringColor, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    private func formatStringWithYTVideo(text: String) -> String {
        let iframeTexts = matches(for: ".*iframe.*", in: text)
        var newText = text
        
        if !iframeTexts.isEmpty {
            iframeTexts.forEach { iframeText in
                let iframeId = matches(for: "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)", in: iframeText);
                
                if !iframeId.isEmpty {
                    
                    let ytString = """
                    <a href='https://www.youtube.com/watch?v=\(iframeId[0])'>YouTube</a>
                    """
                    newText = newText.replacingOccurrences(of: iframeText, with: ytString)
                }
            }
        }
        
        return newText
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex,  options: .caseInsensitive)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            #if DEBUG
            print("invalid regex: \(error.localizedDescription)")
            #endif
            return []
        }
    }
    
}
