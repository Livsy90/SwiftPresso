import Observation
import SwiftUI

@Observable
final class PostViewModel {
    
    var attributedContent: AttributedString = .init()
    var title: String
    var date: Date?
    var attributedString: NSAttributedString = .init()
    var t: String
    var isLoading: Bool = true
        
    @ObservationIgnored
    @SwiftPressoInjected(\.htmlMapper)
    private var mapper: HTMLMapperProtocol
    
    private let htmlString: String
    private let width: CGFloat
    
    init(post: PostModel, width: CGFloat) {
        t = post.content
        title = post.title
        date = post.date
        htmlString = post.content
        self.width = width
    }
    
    func onAppear() {
        var attributedString = self.attributedString
        DispatchQueue.global(qos: .userInitiated).async {
            attributedString = self.mapper.attributedStringFrom(
                htmlText: self.htmlString,
                width:self.width
            )
            DispatchQueue.main.async {
                self.attributedString = attributedString
                self.isLoading = false
            }
        }
    }
    
}
