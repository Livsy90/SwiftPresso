import Observation
import SwiftUI

@Observable
final class PostViewModel {
    
    var attributedString: NSAttributedString = .init()
    var isLoading: Bool = true
    var url: URL?
    var size: CGSize = UIScreen.main.bounds.size
    
    @ObservationIgnored
    @SwiftPressoInjected(\.htmlMapper)
    private var mapper: HTMLMapperProtocol
    
    @ObservationIgnored
    @SwiftPressoInjected(\.post)
    private var postProvider: PostProviderProtocol
    
    private let htmlString: String
    private let title: String
    private let date: Date?
    
    init(post: PostModel) {
        title = post.title
        date = post.date
        url = post.link
        htmlString = post.content
    }
    
    func onAppear() {
        let html = htmlTitle().appending(htmlDate()).appending(htmlString)
        var attributedString = self.attributedString
        DispatchQueue.global(qos: .userInitiated).async {
            attributedString = self.mapper.attributedStringFrom(
                htmlText: html,
                width: self.size.width
            )
            DispatchQueue.main.async {
                self.attributedString = attributedString
                self.isLoading = false
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
    
    private func htmlTitle() -> String {
        "<h1>\(title)</h1>"
    }
    
    private func htmlDate() -> String {
        "<h5>\(date?.formatted(date: .numeric, time: .omitted) ?? "")</h5>"
    }
    
}
