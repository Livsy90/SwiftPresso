import SwiftUI

public protocol HTMLMapperProtocol: Sendable {
    
    /// Create an ``NSMutableAttributedString`` value from an HTML string.
    /// - Parameters:
    ///   - htmlText: HTML text to parse.
    ///   - color: Text color.
    ///   - fontSize: Text font size.
    ///   - width: Width of images and YouTube previews.
    ///   - isHandleYouTubeVideos:
    /// - Returns: If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with an active link.
    func attributedStringFrom(
        htmlText: String,
        color: UIColor,
        fontSize: CGFloat,
        width: CGFloat,
        isHandleYouTubeVideos: Bool
    ) -> AttributedString
}
