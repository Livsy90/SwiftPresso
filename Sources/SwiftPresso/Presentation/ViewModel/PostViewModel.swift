import Observation
import SwiftUI

@Observable
final class PostViewModel {
    
    var attributedString: NSAttributedString = .init()
    var isInitialLoading: Bool = true
    var isShowContent: Bool = false
    var isLoading: Bool = false
    var url: URL?
    var featuredImageURL: URL?
    var title: String
    var date: Date?
    
    @ObservationIgnored
    @SwiftPressoInjected(\.htmlMapper)
    private var mapper: any HTMLMapperProtocol
    
    @ObservationIgnored
    @SwiftPressoInjected(\.postProvider)
    private var postProvider: any PostProviderProtocol
    
    private let htmlString: String
    private let width: CGFloat
    
    init(post: PostModel, width: CGFloat) {
        title = post.title
        date = post.date
        url = post.link
        featuredImageURL = post.imgURL
        htmlString = post.content
        self.width = width
    }
    
    func onAppear() {
        var attributedString = self.attributedString
        DispatchQueue.global(qos: .userInteractive).async {
            attributedString = self.mapper.attributedStringFrom(
                htmlText: self.htmlString,
                color: UIColor(SwiftPresso.Configuration.UI.textColor),
                font: SwiftPresso.Configuration.UI.postBodyFont,
                width: self.width - 44,
                isHandleYouTubeVideos: SwiftPresso.Configuration.UI.isParseHTMLWithYouTubePreviews
            )
            DispatchQueue.main.async {
                self.attributedString = attributedString
                self.isInitialLoading = false
                withAnimation {
                    self.isShowContent = true
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
