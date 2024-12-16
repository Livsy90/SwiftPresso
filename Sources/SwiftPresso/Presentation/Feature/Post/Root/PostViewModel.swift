import Observation
import SwiftUI

@Observable
final class PostViewModel {
    
    private enum Constants {
        static let padding: CGFloat = 44
    }
    
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
        Task {
            async let attributedString = mapper.attributedStringFrom(
                htmlText: htmlString,
                color: UIColor(SwiftPresso.Configuration.UI.textColor),
                fontSize: SwiftPresso.Configuration.UI.postBodyFont.pointSize,
                width: width - Constants.padding,
                isHandleYouTubeVideos: SwiftPresso.Configuration.UI.isParseHTMLWithYouTubePreviews
            )
            
            self.attributedString = await NSAttributedString(attributedString)
            isInitialLoading = false
            withAnimation {
                isShowContent = true
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
