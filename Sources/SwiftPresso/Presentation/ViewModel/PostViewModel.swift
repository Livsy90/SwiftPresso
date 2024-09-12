import Observation
import SwiftUI

@Observable
final class PostViewModel {
    
    var attributedContent: AttributedString = .init()
    var title: String
    var date: Date?
    
    var isLoading: Bool = true
        
    @ObservationIgnored
    @SwiftPressoInjected(\.htmlMapper)
    private var mapper: HTMLMapperProtocol
    
    private let htmlString: String
    private let width: CGFloat
    
    init(post: PostModel, width: CGFloat) {
        title = post.title
        date = post.date
        htmlString = post.content
        self.width = width
    }
    
    func onAppear() {
        var attributedContent = self.attributedContent
        DispatchQueue.global(qos: .userInitiated).async {
            attributedContent = AttributedString(
                self.mapper.attributedStringFrom(
                    htmlText: self.htmlString,
                    width:self.width
                )
            )
            attributedContent.foregroundColor = SwiftPresso.Configuration.textColor
            attributedContent.font = .body
            
            DispatchQueue.main.async {
                self.attributedContent = attributedContent
                self.isLoading = false
            }
        }
    }
    
}
