import Observation
import Foundation

@Observable
@MainActor
final class PostListViewModel {
    
    enum ListMode {
        case common
        case tag(String)
        case category(String)
        case search(String)
        
        var title: String {
            switch self {
            case .common:
                SwiftPresso.Configuration.UI.homeTitle
            case .tag(let title):
                title
            case .category(let title):
                title
            case .search:
                SwiftPresso.Configuration.UI.searchTitle
            }
        }
    }
    
    var isInitialLoading: Bool {
        isLoading && shouldShowFullScreenPlaceholder
    }
    var isLoadMore: Bool {
        isLoading && !isError && !isInitialLoading
    }
    private(set) var isLoading: Bool = true
    private(set) var postList: [PostModel] = []
    private(set) var pageList: [PostModel] = []
    private(set) var tags: [CategoryModel] = []
    private(set) var categories: [CategoryModel] = []
    private(set) var isRefreshable: Bool = false
    private(set) var mode: ListMode = .common {
        didSet {
            shouldShowFullScreenPlaceholder = true
            isError = false
        }
    }
    
    private let postPerPage: Int
    
    @ObservationIgnored
    private var postListProvider: some PostListProviderProtocol = SwiftPresso.Provider.postListProvider()
    
    @ObservationIgnored
    private var categoryListProvider: some CategoryListProviderProtocol = SwiftPresso.Provider.categoryListProvider()
    
    @ObservationIgnored
    private var tagListProvider: some TagListProviderProtocol = SwiftPresso.Provider.tagListProvider()
    
    @ObservationIgnored
    private var pageListProvider: some PageListProviderProtocol = SwiftPresso.Provider.pageListProvider()
    
    private var pageNumber = 1
    private var shouldShowFullScreenPlaceholder = true
    private var isError: Bool = false
    
    private var postListTask: Task<Void, Never>?
    
    init(postPerPage: Int) {
        self.postPerPage = postPerPage
        
        Task {
            async let postList = await getPostList(pageNumber: 1)
            async let pageList = await getPages()
            self.postList = try await postList
            self.pageList = await pageList
            shouldShowFullScreenPlaceholder = false
            
            async let tags = await getTags()
            async let categories = await getCategories()
            self.categories = await categories
            self.tags = await tags
            pageNumber += 1
            isLoading = false
        }
    }
    
}

// MARK: - Functions

extension PostListViewModel {
    
    func updateIfNeeded(id: Int) {
        guard let last = postList.last, id == last.id, !isLoading else { return }
        loadPosts()
    }
    
    func search(_ text: String) {
        mode = .search(text)
        reset()
        loadPosts()
    }
    
    func loadDefault() {
        isRefreshable = false
        mode = .common
        reset()
        loadPosts()
    }
    
    func reload() {
        shouldShowFullScreenPlaceholder = true
        reset()
        loadPosts()
    }
    
    func onTag(_ name: String) {
        isRefreshable = true
        mode = .tag(name.replacingOccurrences(of: "-", with: " ").capitalized)
        reset()
        loadPosts()
    }
    
    func onCategory(_ name: String) {
        isRefreshable = true
        mode = .category(name.replacingOccurrences(of: "-", with: " ").capitalized)
        reset()
        loadPosts()
    }
    
}

// MARK: - Private Functions

private extension PostListViewModel {
    
    func loadPosts() {
        postListTask?.cancel()
        postListTask = Task {
            await _loadPosts()
        }
    }
    
    func _loadPosts() async {
        isLoading = true
        switch mode {
        case .common:
            do {
                var postList = self.postList
                postList += try await getPostList(pageNumber: pageNumber)
                try Task.checkCancellation()
                self.postList = postList
            } catch {
                isError = true
            }
            
        case .tag(let name):
            do {
                var postList = self.postList
                postList += try await getPostList(
                    pageNumber: pageNumber,
                    tag: id(by: name)
                )
                try Task.checkCancellation()
                self.postList = postList
            } catch {
                isError = true
            }
            
        case .category(let name):
            do {
                var postList = self.postList
                postList += try await getPostList(
                    pageNumber: pageNumber,
                    category: id(by: name)
                )
                try Task.checkCancellation()
                self.postList = postList
            } catch {
                isError = true
            }
            
        case .search(let searchTerms):
            do {
                var postList = self.postList
                postList += try await getPostList(
                    pageNumber: pageNumber,
                    searchTerms: searchTerms
                )
                try Task.checkCancellation()
                self.postList = postList
            } catch {
                isError = true
            }
        }
        
        pageNumber += 1
        isLoading = false
        shouldShowFullScreenPlaceholder = false
    }
    
    func getPostList(
        pageNumber: Int,
        searchTerms: String? = nil,
        category: Int? = nil,
        tag: Int? = nil
    ) async throws -> [PostModel] {
        do {
            defer {
                isError = false
            }
            return try await postListProvider.getPosts(
                pageNumber: pageNumber,
                perPage: postPerPage,
                searchTerms: searchTerms,
                categories: CollectionOfOne(category).compactMap { $0 },
                tags: CollectionOfOne(tag).compactMap { $0 },
                includeIDs: nil
            )
        } catch {
            throw error
        }
    }
    
    func getTags() async -> [CategoryModel] {
        do {
            return try await tagListProvider.getTags()
        } catch {
            isError = true
            return []
        }
    }
    
    func getCategories() async -> [CategoryModel]  {
        do {
            return try await categoryListProvider.getCategories()
        } catch {
            isError = true
            return []
        }
    }
    
    func getPages() async -> [PostModel]  {
        do {
            return try await pageListProvider.getPages()
        } catch {
            isError = true
            return []
        }
    }
    
    func reset() {
        isError = false
        pageNumber = 1
        postList.removeAll()
    }
    
    func id(by name: String) -> Int? {
        let categoryArray: [CategoryModel]
        
        switch mode {
        case .common, .search:
            categoryArray = []
        case .tag:
            categoryArray = tags
        case .category:
            categoryArray = categories
        }
        
        return categoryArray
            .filter { $0.name.compare(name, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame }
            .map { $0.id }
            .first
    }
    
}
