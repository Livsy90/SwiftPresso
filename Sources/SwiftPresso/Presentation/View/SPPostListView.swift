import SwiftUI

struct SPPostListView<Placeholder: View>: View {
    
    let loadingPlaceholder: () -> Placeholder
    
    @State private var viewModel: SPPostListViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var urlToOpen: URL?
    
    @State private var isShowSideMenu = false
    @State private var isTagMenuExpanded = false
    @State private var isCategoryMenuExpanded = false
    @State private var isPageMenuExpanded = false
    
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
                    if isShowTagMenu || isShowCategoryMenu || isShowPageMenu {
                        Button {
                            withAnimation {
                                self.isShowSideMenu = true
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3")
                        }
                        
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    ProgressView()
                        .opacity(viewModel.isLoadMore ? 1 : 0)
                        .animation(.easeInOut(duration: viewModel.isLoadMore ? 0 : 0.5), value: viewModel.isLoadMore)
                    
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
        .sideMenu(isShowing: $isShowSideMenu) {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation {
                        self.isShowSideMenu = false
                    }
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                Divider()
                    .padding()
                
                List {
                    if isShowTagMenu {
                        Section("Tags", isExpanded: $isTagMenuExpanded) {
                            ForEach(viewModel.tags, id: \.self) { tag in
                                Button {
                                    withAnimation {
                                        self.isShowSideMenu = false
                                    }
                                    Task {
                                        await viewModel.onTag(tag.name)
                                    }
                                } label: {
                                    Text(tag.name)
                                }
                            }
                        }
                        .disabled(viewModel.isTagsUnavailable || viewModel.isLoading)
                    }
                    
                    if isShowCategoryMenu {
                        Section("Category", isExpanded: $isCategoryMenuExpanded) {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Button {
                                    withAnimation {
                                        self.isShowSideMenu = false
                                    }
                                    Task {
                                        await viewModel.onTag(category.name)
                                    }
                                } label: {
                                    Text(category.name)
                                }
                            }
                        }
                        .disabled(viewModel.isCategoriesUnavailable || viewModel.isLoading)
                    }
                
                    if isShowPageMenu {
                    Section("Category", isExpanded: $isPageMenuExpanded) {
                        ForEach(viewModel.pageList, id: \.self) { page in
                            Button {
                                withAnimation {
                                    self.isShowSideMenu = false
                                }
                                if let url = page.link {
                                    urlToOpen = url
                                }
                            } label: {
                                Text(page.title)
                            }
                        }
                    }
                    .disabled(viewModel.isPagesUnavailable || viewModel.isLoading)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
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
