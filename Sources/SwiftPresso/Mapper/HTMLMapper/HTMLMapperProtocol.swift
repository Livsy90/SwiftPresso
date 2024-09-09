import Foundation

public protocol HTMLMapperProtocol {
    func attributedStringFrom(htmlText: String, width: CGFloat) -> NSMutableAttributedString
}
