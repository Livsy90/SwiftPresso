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
    private var mapper: some HTMLMapperProtocol = SwiftPresso.Mapper.htmlMapper()
    
    @ObservationIgnored
    private var postProvider: some PostProviderProtocol = SwiftPresso.Provider.postProvider()
    
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
    
    @MainActor
    func onAppear() {
        var attributedString = AttributedString(attributedString)
        Task(priority: .background) {
            attributedString = self.mapper.attributedStringFrom(
                htmlText: self.htmlString,
                color: UIColor(SwiftPresso.Configuration.UI.textColor),
                fontSize: SwiftPresso.Configuration.UI.postBodyFont.pointSize,
                width: self.width - 44,
                isHandleYouTubeVideos: SwiftPresso.Configuration.UI.isParseHTMLWithYouTubePreviews
            )
            
            Task(priority: .high) {
                self.attributedString = NSAttributedString(attributedString)
                self.isInitialLoading = false
                withAnimation {
                    self.isShowContent = true
                }
            }
        }
    }
    
    @MainActor
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
