import Observation
import SwiftUI

@Observable
@MainActor
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
    var error: Error?
    
    private let mapper: some HTMLMapperProtocol = SwiftPresso.Mapper.htmlMapper()
    private let postProvider: some PostProviderProtocol = SwiftPresso.Provider.postProvider()
    
    private var htmlString: String
    private let width: CGFloat
    
    private let isPasswordProtected: Bool
    private let postID: Int
    
    init(post: PostModel, width: CGFloat) {
        title = post.title
        date = post.date
        url = post.link
        featuredImageURL = post.imgURL
        isPasswordProtected = post.isPasswordProtected
        postID = post.id
        htmlString = post.content
        self.width = width
    }
    
    func onAppear(_ onNotAvailable: @escaping () -> Void) async {
        guard isPasswordProtected else {
            await composeContent()
            return
        }
        
        guard !Preferences.contentPassword.isEmpty else {
            onNotAvailable()
            return
        }
        
        do {
            let post = try await postProvider.getPost(id: postID, password: Preferences.contentPassword)
            htmlString = post.content
            featuredImageURL = post.imgURL
            await composeContent()
        } catch {
            self.error = error
        }
    }
    
    func post(with id: Int) async throws -> PostModel {
        defer {
            isLoading = false
        }
        isLoading = true
        
        return try await postProvider.getPost(id: id, password: Preferences.contentPassword)
    }
    
}

private extension PostViewModel {
    
    func composeContent() async {
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
