import Observation
import SwiftUI

@Observable
final class PostViewModel {
    
    var attributedString: NSAttributedString = .init()
    var isInitialLoading: Bool = true
    var isLoading: Bool = false
    var url: URL?
    var title: String
    var date: Date?
    
    @ObservationIgnored
    @SwiftPressoInjected(\.htmlMapper)
    private var mapper: any HTMLMapperProtocol
    
    @ObservationIgnored
    @SwiftPressoInjected(\.postProvider)
    private var postProvider: any PostProviderProtocol
    
    private let htmlString: String
    
    init(post: PostModel) {
        title = post.title
        date = post.date
        url = post.link
        htmlString = post.content
    }
    
    func onAppear() {
        var attributedString = self.attributedString
        let width = (UIScreen.current?.bounds.size.width ?? .zero) - 44
        DispatchQueue.global(qos: .userInteractive).async {
            attributedString = self.mapper.attributedStringFrom(
                htmlText: self.htmlString,
                color: UIColor(SwiftPresso.Configuration.textColor),
                fontStyle: .callout,
                width: width,
                isHandleYouTubeVideos: SwiftPresso.Configuration.isParseHTMLWithYouTubePreviews
            )
            DispatchQueue.main.async {
                self.attributedString = attributedString
                withAnimation {
                    self.isInitialLoading = false
                }
            }
        }
    }
    
    func post(with id: Int) async throws -> PostModel {
        defer {
            isLoading = false
        }
        isLoading = true
        do {
            return try await postProvider.getPost(id: id)
        } catch {
            throw error
        }
    }
    
}
