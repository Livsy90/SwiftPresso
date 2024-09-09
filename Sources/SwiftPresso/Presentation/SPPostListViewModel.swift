//
//  PostListViewModel.swift
//  LivsyCode
//
//  Created by Livsy on 28.08.2024.
//

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
            case .common: "Home"
            case .tag(let title): title
            case .category(let title): title
            case .search: "Search"
            }
        }
    }
    
    var isInitialLoading: Bool {
        isLoading && shouldShowFullScreenPlaceholder
    }
    var isLoadMore: Bool {
        isLoading && !isError
    }
    private(set) var isLoading: Bool = true
    private(set) var postList: [PostModel] = []
    private(set) var pageList: [PostModel] = [] {
        didSet {
            isMenuUnavailable = pageList.isEmpty
        }
    }
    private(set) var tags: [CategoryModel] = []
    private(set) var categories: [CategoryModel] = []
    
    private(set) var isRefreshable: Bool = false
    private(set) var isMenuUnavailable: Bool = true
    private(set) var mode: ListMode = .common {
        didSet {
            shouldShowFullScreenPlaceholder = true
            isError = false
        }
    }
    
    private let postListManager = SPFactory.postListManager()
    private let categoryListManager = SPFactory.categoryListManager()
    private let tagListManager = SPFactory.tagListManager()
    private let pageListManager = SPFactory.pageListManager()
    private let settings = SPSettings.shared
    
    private var pageNumber = 1
    private var shouldShowFullScreenPlaceholder = true
    private var isError: Bool = false
    
    init(configuration: SPSettings.Configuration) {
        SPSettings.shared.configure(with: configuration)
        
        Task {
            async let postList = await getPostList()
            async let pageList = await getPages()
            self.postList = await postList
            self.pageList = await pageList
            shouldShowFullScreenPlaceholder = false
            
            async let tags = await getTags()
            async let categories = await getCategories()
            self.categories = await categories
            self.tags = await tags
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
            self.postList += await getPostList()
            
        case .tag(let name):
            self.postList += await getPostList(tag: id(by: name))
            
        case .category(let name):
            self.postList += await getPostList(category: id(by: name))
            
        case .search(let searchTerms):
            self.postList += await getPostList(searchTerms: searchTerms)
        }
        
        isLoading = false
        shouldShowFullScreenPlaceholder = false
        pageNumber += 1
    }
    
    private func getPostList(
        searchTerms: String? = nil,
        category: Int? = nil,
        tag: Int? = nil
    ) async -> [PostModel] {
        do {
            return try await postListManager.getPosts(
                pageNumber: pageNumber,
                perPage: settings.postsPerPage,
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
            return try await tagListManager.getTags()
        } catch {
            isError = true
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getCategories() async -> [CategoryModel]  {
        do {
            return try await categoryListManager.getCategories()
        } catch {
            isError = true
            print(error.localizedDescription)
            return []
        }
    }
    
    private func getPages() async -> [PostModel]  {
        do {
            return try await pageListManager.getPages()
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
