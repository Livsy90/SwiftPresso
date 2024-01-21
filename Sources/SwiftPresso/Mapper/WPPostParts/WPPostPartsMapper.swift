import Foundation
import UIKit

public struct PostDataMapper: WPPostPartsMapperProtocol {
    
    private let htmlMapper: HTMLMapperProtocol
    
    public init(htmlMapper: HTMLMapperProtocol) {
        self.htmlMapper = htmlMapper
    }
    
    public func map(htmlString: String) -> [WPPostParts] {
        let attributedString = htmlMapper.attributedStringFrom(htmlText: htmlString)
        let postParts = map(attributedString: attributedString)
        let configuredPostParts = map(postParts)
        
        return configuredPostParts
    }
     
    private func map(attributedString: NSMutableAttributedString) -> [WPPostParts] {
        var parts = [WPPostParts]()
        
        let range = NSMakeRange(0, attributedString.length)
        attributedString.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { object, range, _ in
            
            let postData = WPPostParts(
                image: (object[NSAttributedString.Key.attachment] as? NSTextAttachment)?.getImage(range: range),
                url: (object[NSAttributedString.Key.link] as? NSURL)?.absoluteURL,
                text: attributedString.attributedSubstring(from: range)
            )
            
            parts.append(postData)
        }
        
        return parts
    }
    
    private func map(_ parts: [WPPostParts]) -> [WPPostParts] {
        var new: [WPPostParts] = []
        var previousValue = WPPostParts()
        
        parts.forEach {
            guard $0.hasText && previousValue.hasText else {
                new.append($0)
                previousValue = $0
                return
            }
            
            let firstString = previousValue.text ?? NSAttributedString(string: "")
            let secondString = $0.text ?? NSAttributedString(string: "")
            let concatinatedStrings = firstString + secondString
            let newData = WPPostParts(text: concatinatedStrings)
            previousValue = newData
            _ = new.popLast()
            new.append(newData)
        }
        
        return new
    }
}

fileprivate extension NSTextAttachment {
    func getImage(range: NSRange) -> UIImage? {
        if let image = image {
            return image
        } else if let image = image(forBounds: bounds, textContainer: nil, characterIndex: range.location) {
            return image
        } else {
            return nil
        }
    }
}

fileprivate extension NSAttributedString {
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let leftCopy = NSMutableAttributedString(attributedString: left)
        leftCopy.append(right)
        return leftCopy
    }
}
