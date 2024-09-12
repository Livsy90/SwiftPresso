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
        attributedContent = AttributedString(mapper.attributedStringFrom(htmlText: htmlString, width: width))
        attributedContent.foregroundColor = SwiftPresso.Configuration.textColor
        attributedContent.font = .body
        isLoading = false
    }
    
}
