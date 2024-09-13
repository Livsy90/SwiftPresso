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
    private var mapper: HTMLMapperProtocol
    
    @ObservationIgnored
    @SwiftPressoInjected(\.post)
    private var postProvider: PostProviderProtocol
    
    private let htmlString: String
    
    init(post: PostModel) {
        title = post.title
        date = post.date
        url = post.link
        htmlString = post.content
    }
    
    func onAppear() {
        var attributedString = self.attributedString
        DispatchQueue.global(qos: .userInitiated).async {
            attributedString = self.mapper.attributedStringFrom(
                htmlText: self.htmlString,
                width: UIScreen.current?.bounds.size.width ?? .zero
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
