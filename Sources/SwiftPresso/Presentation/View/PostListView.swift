import SwiftUI

struct PostListView<Placeholder: View>: View {
    
    let loadingPlaceholder: () -> Placeholder
    
    @State private var viewModel: PostListViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var urlToOpen: URL?
    
    @State private var isShowMenu = false
    
    @State private var isPageMenuExpanded: Bool
    @State private var isTagMenuExpanded: Bool
    @State private var isCategoryMenuExpanded: Bool
    
    private let backgroundColor: Color
    private let interfaceColor: Color
    private let textColor: Color
    
    private let homeIcon: Image
    
    private let isShowPageMenu: Bool
    private let isShowTagMenu: Bool
    private let isShowCategoryMenu: Bool
    
    private let pageMenuTitle: String
    private let tagMenuTitle: String
    private let categoryMenuTitle: String
    
    private let menuBackgroundColor: Color
    private let menuTextColor: Color
    
    init(
        backgroundColor: Color,
        interfaceColor: Color,
        textColor: Color,
        menuBackgroundColor: Color,
        menuTextColor: Color,
        homeIcon: Image,
        isShowPageMenu: Bool,
        isShowTagMenu: Bool,
        isShowCategoryMenu: Bool,
        isMenuExpanded: Bool,
        pageMenuTitle: String,
        tagMenuTitle: String,
        categoryMenuTitle: String,
        postPerPage: Int,
        loadingPlaceholder: @escaping () -> Placeholder
    ) {
        
        self.viewModel = PostListViewModel(postPerPage: postPerPage)
        
        self.backgroundColor = backgroundColor
        self.interfaceColor = interfaceColor
        self.textColor = textColor
        
        self.menuBackgroundColor = menuBackgroundColor
        self.menuTextColor = menuTextColor
        
        self.isShowTagMenu = isShowTagMenu
        self.isShowCategoryMenu = isShowCategoryMenu
        self.isShowPageMenu = isShowPageMenu
        
        self.homeIcon = homeIcon
        
        self.pageMenuTitle = pageMenuTitle
        self.tagMenuTitle = tagMenuTitle
        self.categoryMenuTitle = categoryMenuTitle
        
        self.loadingPlaceholder = loadingPlaceholder
        
        self.isPageMenuExpanded = isMenuExpanded
        self.isTagMenuExpanded = isMenuExpanded
        self.isCategoryMenuExpanded = isMenuExpanded
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.postList, id: \.self) { post in
                    PostListRow(
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
                    placeholder()
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                
                if viewModel.isLoadMore {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .id(UUID())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .padding(.horizontal)
                }
            }
            .listStyle(.plain)
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
                    if isShowTagMenu || isShowPageMenu || isShowCategoryMenu {
                        Button {
                            withAnimation {
                                isShowMenu = true
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3")
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
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
                        .id(UUID())
                }
            )
        }
        .tint(interfaceColor)
        .sideMenu(isShowing: $isShowMenu) {
            menu()
        }
    }
    
    private func placeholder() -> some View {
        loadingPlaceholder()
            .id(UUID())
    }
    
    private func menu() -> some View {
        VStack {
            Button {
                withAnimation {
                    isShowMenu = false
                }
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 80)
            .accentColor(menuTextColor)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if isShowPageMenu {
                        DisclosureGroup(
                            isExpanded: $isPageMenuExpanded,
                            content: {
                                ForEach(viewModel.pageList, id: \.self) { page in
                                    Button {
                                        withAnimation {
                                            isShowMenu = false
                                        }
                                        if let url = page.link {
                                            urlToOpen = url
                                        }
                                    } label: {
                                        VStack {
                                            HStack {
                                                Text(page.title)
                                                    .font(.callout)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(alignment: .leading)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(menuTextColor)
                                                Spacer()
                                            }
                                        }
                                        .padding(.top)
                                    }
                                }
                            },
                            label: {
                                Text(pageMenuTitle)
                                    .multilineTextAlignment(.leading)
                                    .frame(alignment: .leading)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(menuTextColor)
                            }
                        )
                        .padding()
                        .tint(menuTextColor)
                    }
                    
                    if isShowCategoryMenu {
                        DisclosureGroup(
                            isExpanded: $isCategoryMenuExpanded,
                            content: {
                                ForEach(viewModel.categories, id: \.self) { category in
                                    Button {
                                        withAnimation {
                                            isShowMenu = false
                                        }
                                        Task {
                                            await viewModel.onCategory(category.name)
                                        }
                                    } label: {
                                        VStack {
                                            HStack {
                                                Text(category.name)
                                                    .font(.callout)
                                                    .multilineTextAlignment(.leading)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(menuTextColor)
                                                Spacer()
                                            }
                                        }
                                        .padding(.top)
                                    }
                                }
                            },
                            label: {
                                Text(categoryMenuTitle)
                                    .multilineTextAlignment(.leading)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(menuTextColor)
                            }
                        )
                        .padding()
                        .tint(menuTextColor)
                    }
                    
                    if isShowTagMenu {
                        DisclosureGroup(
                            isExpanded: $isTagMenuExpanded,
                            content: {
                                ForEach(viewModel.tags, id: \.self) { tag in
                                    Button {
                                        withAnimation {
                                            isShowMenu = false
                                        }
                                        Task {
                                            await viewModel.onTag(tag.name)
                                        }
                                    } label: {
                                        VStack {
                                            HStack {
                                                Text(tag.name)
                                                    .font(.callout)
                                                    .multilineTextAlignment(.leading)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(menuTextColor)
                                                Spacer()
                                            }
                                        }
                                        .padding(.top)
                                    }
                                }
                            },
                            label: {
                                Text(tagMenuTitle)
                                    .multilineTextAlignment(.leading)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(menuTextColor)
                            }
                        )
                        .padding()
                        .tint(menuTextColor)
                    }
                    
                    Spacer()
                }
            }
        }
        .background(menuBackgroundColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct PostListRow<Placeholder: View>: View {
    
    let post: PostModel
    let webViewBackgroundColor: Color
    let interfaceColor: Color
    let textColor: Color
    let onTag: (String) -> Void
    let onCategory: (String) -> Void
    let placeholder: () -> Placeholder
    
    var body: some View {
        if let link = post.link {
            LinkView(
                url: link,
                title: post.title,
                webViewBackgroundColor: webViewBackgroundColor,
                interfaceColor: interfaceColor,
                textColor: textColor,
                onTag: onTag,
                onCategory: onCategory,
                placeholder: placeholder
            )
            .padding(.vertical, 8)
        } else {
            Text(post.title)
                .padding(.vertical, 8)
        }
    }
}

#Preview {
    SwiftPresso.View.postListWithDefaultPlaceholder("livsycode.com")
}
