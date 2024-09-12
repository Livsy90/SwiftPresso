import Observation
import SwiftUI

@Observable
final class PostViewModel {
    
    var attributedContent: AttributedString = .init()
    var title: String
    var date: Date?
    var attributedString: NSAttributedString = .init()
    
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
        let html = htmlTitle().appending(htmlDate()).appending(htmlString)
        var attributedString = self.attributedString
        DispatchQueue.global(qos: .userInitiated).async {
            attributedString = self.mapper.attributedStringFrom(
                htmlText: html,
                width:self.width
            )
            DispatchQueue.main.async {
                self.attributedString = attributedString
                self.isLoading = false
            }
        }
    }
    
    private func htmlTitle() -> String {
        "<h1>\(title)</h1>"
    }
    
    private func htmlDate() -> String {
        "<h5>\(date?.formatted(date: .numeric, time: .omitted) ?? "")</h5>"
    }
    
}
