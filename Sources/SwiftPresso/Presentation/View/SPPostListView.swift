import SwiftUI

struct SPPostListView<Placeholder: View>: View {
    
    let loadingPlaceholder: () -> Placeholder
    
    @State private var viewModel: SPPostListViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var urlToOpen: URL?
    
    @State private var isShowMenu = false
    
    private let backgroundColor: Color
    private let interfaceColor: Color
    private let textColor: Color
    
    private let homeIcon: Image
    private let tagIcon: Image
    private let pageIcon: Image
    private let categoryIcon: Image
    
    private let isShowPageMenu: Bool
    private let isShowTagMenu: Bool
    private let isShowCategoryMenu: Bool
    
    init(
        backgroundColor: Color,
        interfaceColor: Color,
        textColor: Color,
        homeIcon: Image,
        tagIcon: Image,
        pageIcon: Image,
        categoryIcon: Image,
        isShowPageMenu: Bool,
        isShowTagMenu: Bool,
        isShowCategoryMenu: Bool,
        postPerPage: Int,
        loadingPlaceholder: @escaping () -> Placeholder
    ) {
        
        self.viewModel = SPPostListViewModel(postPerPage: postPerPage)
        
        self.backgroundColor = backgroundColor
        self.interfaceColor = interfaceColor
        self.textColor = textColor
        
        self.isShowTagMenu = isShowTagMenu
        self.isShowCategoryMenu = isShowCategoryMenu
        self.isShowPageMenu = isShowPageMenu
        
        self.homeIcon = homeIcon
        self.tagIcon = tagIcon
        self.pageIcon = pageIcon
        self.categoryIcon = categoryIcon
        
        self.loadingPlaceholder = loadingPlaceholder
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.postList, id: \.self) { post in
                    SPPostListRow(
                        post: post,
                        webViewBackgroundColor: backgroundColor,
                        interfaceColor: interfaceColor,
                        textColor: textColor,
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
                            loadingPlaceholder()
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
                    loadingPlaceholder()
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                }
                
                if viewModel.isLoadMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .id(UUID())
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.mode.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(interfaceColor)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            isShowMenu = true
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.loadDefault()
                        }
                    } label: {
                        homeIcon
                    }
                    .opacity(viewModel.isRefreshable ? 1 : 0)
                    .animation(.default, value: viewModel.isRefreshable)
                    .symbolEffect(.bounce, value: viewModel.isRefreshable)
                    .disabled(viewModel.isLoading)
                    
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
                            tagIcon
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
                            categoryIcon
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
                            pageIcon
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
                interfaceColor: interfaceColor,
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
                    loadingPlaceholder()
                }
            )
        }
        .tint(interfaceColor)
        .sideMenu(isShowing: $isShowMenu) {
            ScrollView {
                VStack(alignment: .leading) {
                    if isShowPageMenu {
                        DisclosureGroup {
                            ForEach(viewModel.pageList, id: \.self) { page in
                                Button {
                                    withAnimation {
                                        isShowMenu = false
                                    }
                                    if let url = page.link {
                                        urlToOpen = url
                                    }
                                } label: {
                                    Text(page.title)
                                }
                            }
                        } label: {
                            Text("Pages")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                    
                    if isShowCategoryMenu {
                        DisclosureGroup {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Button {
                                    withAnimation {
                                        isShowMenu = false
                                    }
                                    Task {
                                        await viewModel.onCategory(category.name)
                                    }
                                } label: {
                                    Text(category.name)
                                }
                            }
                        } label: {
                            Text("Categories")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                    
                    if isShowTagMenu {
                        DisclosureGroup {
                            ForEach(viewModel.tags, id: \.self) { tag in
                                Button {
                                    withAnimation {
                                        isShowMenu = false
                                    }
                                    Task {
                                        await viewModel.onCategory(tag.name)
                                    }
                                } label: {
                                    Text(tag.name)
                                }
                            }
                        } label: {
                            Text("Tags")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

private struct SPPostListRow<Placeholder: View>: View {
    
    let post: PostModel
    let webViewBackgroundColor: Color
    let interfaceColor: Color
    let textColor: Color
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    var body: some View {
        if let link = post.link {
            SPLinkView(
                url: link,
                title: post.title,
                webViewBackgroundColor: webViewBackgroundColor,
                interfaceColor: interfaceColor,
                textColor: textColor,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
        } else {
            Text(post.title)
        }
    }
}
