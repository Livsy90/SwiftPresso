import Observation
import Foundation

@Observable
final class SPPostListViewModel {
    
    enum ListMode {
        case common
        case tag(String)
        case category(String)
        case search(String)
        
        var title: String {
            switch self {
            case .common: 
                SwiftPresso.Configuration.homeTitle ?? "Home"
            case .tag(let title):
                title
            case .category(let title):
                title
            case .search: 
                SwiftPresso.Configuration.searchTitle ?? "Search"
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
    
    @ObservationIgnored
    @SwiftPressoProvider(\.postList)
    private var postListProvider: PostListProviderProtocol
    
    @ObservationIgnored
    @SwiftPressoProvider(\.categoryList)
    private var categoryListProvider: CategoryListProviderProtocol
    
    @ObservationIgnored
    @SwiftPressoProvider(\.tagList)
    private var tagListProvider: TagListProviderProtocol
    
    @ObservationIgnored
    @SwiftPressoProvider(\.pageList)
    private var pageListProvider: PageListProviderProtocol
    
    private let postPerPage: Int
    
    private var pageNumber = 1
    private var shouldShowFullScreenPlaceholder = true
    private var isError: Bool = false
    
    init(postPerPage: Int) {
        self.postPerPage = postPerPage
        
        Task {
            async let postList = await getPostList(pageNumber: 1)
            async let pageList = await getPages()
            self.postList = await postList
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
    
    func updateIfNeeded(id: Int) async {
        guard let last = postList.last, id == last.id, !isLoading else { return }
        await loadPosts()
    }
    
    func search(_ text: String) async {
        mode = .search(text)
        reset()
        await loadPosts()
    }
    
    func loadDefault() async {
        isRefreshable = false
        mode = .common
        reset()
        await loadPosts()
    }
    
    func reload() async {
        shouldShowFullScreenPlaceholder = true
        reset()
        await loadPosts()
    }
    
    func onTag(_ name: String) async {
        isRefreshable = true
        mode = .tag(name.replacingOccurrences(of: "-", with: " ").capitalized)
        reset()
        await loadPosts()
    }
    
    func onCategory(_ name: String) async {
        isRefreshable = true
        mode = .category(name.replacingOccurrences(of: "-", with: " ").capitalized)
        reset()
        await loadPosts()
    }
    
    private func loadPosts() async {
        isLoading = true
        switch mode {
        case .common:
            self.postList += await getPostList(pageNumber: pageNumber)
            
        case .tag(let name):
            self.postList += await getPostList(
                pageNumber: pageNumber,
                tag: id(by: name)
            )
            
        case .category(let name):
            self.postList += await getPostList(
                pageNumber: pageNumber,
                category: id(by: name)
            )
            
        case .search(let searchTerms):
            self.postList += await getPostList(
                pageNumber: pageNumber,
                searchTerms: searchTerms
            )
        }
        
        pageNumber += 1
        isLoading = false
        shouldShowFullScreenPlaceholder = false
    }
    
    private func getPostList(
        pageNumber: Int,
        searchTerms: String? = nil,
        category: Int? = nil,
        tag: Int? = nil
    ) async -> [PostModel] {
        do {
            return try await postListProvider.getRefinedPosts(
                pageNumber: pageNumber,
                perPage: postPerPage,
                searchTerms: searchTerms,
                categories: CollectionOfOne(category).compactMap { $0 },
                tags: CollectionOfOne(tag).compactMap { $0 }
            )
        } catch {
            isError = true
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getTags() async -> [CategoryModel] {
        do {
            return try await tagListProvider.getTags()
        } catch {
            isError = true
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getCategories() async -> [CategoryModel]  {
        do {
            return try await categoryListProvider.getCategories()
        } catch {
            isError = true
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getPages() async -> [PostModel]  {
        do {
            return try await pageListProvider.getPages()
        } catch {
            isError = true
            print(error.localizedDescription)
            return []
        }
    }
    
    private func reset() {
        isError = false
        pageNumber = 1
        postList.removeAll()
    }
    
    private func id(by name: String) -> Int? {
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
