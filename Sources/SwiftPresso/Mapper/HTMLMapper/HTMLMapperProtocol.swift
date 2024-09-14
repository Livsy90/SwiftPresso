import UIKit

public protocol HTMLMapperProtocol {
    
    /// Create an ``NSMutableAttributedString`` value from an HTML string.
    /// - Parameters:
    ///   - htmlText: HTML text to parse.
    ///   - color: Text color.
    ///   - fontStyle: Text font style.
    ///   - width: Width of images and YouTube previews.
    ///   - isHandleYouTubeVideos:
    /// - Returns: If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with a clickable link.
    func attributedStringFrom(
        htmlText: String,
        color: UIColor,
        fontStyle: UIFont.TextStyle,
        width: CGFloat,
        isHandleYouTubeVideos: Bool
    ) -> NSMutableAttributedString
}
