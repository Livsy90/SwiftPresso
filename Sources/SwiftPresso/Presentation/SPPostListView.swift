import SwiftUI

public struct SPPostListView<HomePlaceholder: View, PostPlaceholder: View>: View {
    
    public let homePlaceholder: () -> HomePlaceholder
    public let postPlaceholder: () -> PostPlaceholder
    
    @State private var viewModel: SPPostListViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var urlToOpen: URL?
    private let backgroundColor: Color
    private let accentColor: Color
    private let isShowPageMenu: Bool
    private let isShowTagMenu: Bool
    private let isShowCategoryMenu: Bool
    
    public init(
        configuration: SPSettings.Configuration,
        homePlaceholder: @escaping () -> HomePlaceholder,
        postPlaceholder: @escaping () -> PostPlaceholder
    ) {
        
        self.viewModel = SPPostListViewModel(configuration: configuration)
        self.backgroundColor = configuration.backgroundColor
        self.accentColor = configuration.accentColor
        self.homePlaceholder = homePlaceholder
        self.postPlaceholder = postPlaceholder
        self.isShowTagMenu = configuration.isShowTagMenu
        self.isShowCategoryMenu = configuration.isShowCategoryMenu
        self.isShowPageMenu = configuration.isShowPageMenu
    }
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.postList, id: \.self) { post in
                    SPPostListRow(
                        post: post,
                        webViewBackgroundColor: backgroundColor,
                        accentColor: accentColor,
                        onTag: { tagName in
                            Task {
                                await viewModel.onTag(tagName)
                            }
                        },
                        onCategory: { categoryName in
                            Task {
                                await viewModel.onCategory(categoryName)
                            }
                        },
                        placeholder: {
                            postPlaceholder()
                        }
                    )
                    .listRowBackground(Color.clear)
                    .onAppear {
                        Task {
                            await viewModel.updateIfNeeded(id: post.id)
                        }
                    }
                }
                
                if viewModel.isInitialLoading {
                    homePlaceholder()
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                }
                
                if viewModel.isLoadMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .disabled(viewModel.isInitialLoading)
            .scrollContentBackground(.hidden)
            .background {
                Rectangle()
                    .fill(backgroundColor)
                    .edgesIgnoringSafeArea(.all)
            }
            .refreshable {
                Task {
                    await viewModel.reload()
                }
            }
            .navigationTitle(viewModel.mode.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        Task {
                            await viewModel.loadDefault()
                        }
                    } label: {
                        Image(systemName: "house")
                    }
                    .opacity(viewModel.isRefreshable ? 1 : 0)
                    .animation(.default, value: viewModel.isRefreshable)
                    .symbolEffect(.bounce, value: viewModel.isRefreshable)
                    .disabled(viewModel.isLoading)
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    ProgressView()
                        .opacity(viewModel.isLoadMore ? 1 : 0)
                        .animation(.easeInOut(duration: viewModel.isLoadMore ? 0 : 0.5), value: viewModel.isLoadMore)
                    
                    if isShowTagMenu {
                        Menu {
                            ForEach(viewModel.tags, id: \.self) { tag in
                                Button {
                                    Task {
                                        await viewModel.onTag(tag.name)
                                    }
                                } label: {
                                    Text(tag.name)
                                }
                            }
                        } label: {
                            Image(systemName: "tag")
                        }
                        .disabled(viewModel.isTagsUnavailable || viewModel.isLoading)
                    }
                    
                    if isShowCategoryMenu {
                        Menu {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Button {
                                    Task {
                                        await viewModel.onCategory(category.name)
                                    }
                                } label: {
                                    Text(category.name)
                                }
                            }
                        } label: {
                            Image(systemName: "book")
                        }
                        .disabled(viewModel.isCategoriesUnavailable || viewModel.isLoading)
                    }
                    
                    if isShowPageMenu {
                        
                        Menu {
                            ForEach(viewModel.pageList, id: \.self) { page in
                                Button {
                                    if let url = page.link {
                                        urlToOpen = url
                                    }
                                } label: {
                                    Text(page.title)
                                }
                            }
                        } label: {
                            Image(systemName: "list.bullet.below.rectangle")
                        }
                        .disabled(viewModel.isPagesUnavailable || viewModel.isLoading)
                    }
                }
                
            }
            .searchable(text: $searchText, isPresented: $isSearching)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search(searchText)
                }
            }
            .onChange(of: searchText) { _, newValue in
                guard newValue.isEmpty else { return }
                Task {
                    await viewModel.loadDefault()
                }
            }
            .webView(
                url: $urlToOpen,
                backgroundColor: backgroundColor,
                accentColor: accentColor,
                onTag: { tagName in
                    searchText.removeAll()
                    isSearching = false
                    Task {
                        await viewModel.onTag(tagName)
                    }
                },
                onCategory: { categoryName in
                    searchText.removeAll()
                    isSearching = false
                    Task {
                        await viewModel.onCategory(categoryName)
                    }
                },
                placeholder: {
                    postPlaceholder()
                }
            )
        }
        .tint(accentColor)
    }
}

private struct SPPostListRow<Placeholder: View>: View {
    
    let post: PostModel
    let webViewBackgroundColor: Color
    let accentColor: Color
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    var body: some View {
        if let link = post.link {
            SPLinkView(
                url: link,
                title: post.title,
                webViewBackgroundColor: webViewBackgroundColor,
                accentColor: accentColor,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        } else {
            Text(post.title)
        }
    }
}
