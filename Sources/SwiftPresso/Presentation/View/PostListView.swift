import SwiftUI

struct PostListView<Placeholder: View>: View {
    
    let loadingPlaceholder: () -> Placeholder
    
    @State private var viewModel: PostListViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var urlToOpen: URL?
    
    @State private var isShowMenu = false
    
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
                    loadingPlaceholder()
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
                    .padding(.horizontal)
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
                    navigationBarLeadingItems()
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    navigationBarTrailingItems()
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
            menu()
        }
    }
    
    @ViewBuilder
    private func navigationBarLeadingItems() -> some View {
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
    
    private func navigationBarTrailingItems() -> some View {
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
            
            ProgressView()
                .opacity(viewModel.isLoadMore ? 1 : 0)
                .animation(.easeInOut(duration: viewModel.isLoadMore ? 0 : 0.5), value: viewModel.isLoadMore)
        }
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
            .padding()
            .accentColor(menuTextColor)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
                                    VStack {
                                        HStack {
                                            Text(page.title)
                                                .multilineTextAlignment(.leading)
                                                .frame(alignment: .leading)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(menuTextColor)
                                            Spacer()
                                        }
                                        Divider()
                                    }
                                    .padding(.top)
                                }
                            }
                        } label: {
                            Text(pageMenuTitle)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(menuTextColor)
                        }
                        .tint(menuTextColor)
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
                                    VStack {
                                        HStack {
                                            Text(category.name)
                                                .multilineTextAlignment(.leading)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(menuTextColor)
                                            Spacer()
                                        }
                                        Divider()
                                    }
                                    .padding(.top)
                                }
                            }
                        } label: {
                            Text(categoryMenuTitle)
                                .multilineTextAlignment(.leading)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(menuTextColor)
                        }
                        .tint(menuTextColor)
                    }
                    
                    if isShowTagMenu {
                        DisclosureGroup {
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
                                                .multilineTextAlignment(.leading)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(menuTextColor)
                                            Spacer()
                                        }
                                        Divider()
                                    }
                                    .padding(.top)
                                }
                            }
                        } label: {
                            Text(tagMenuTitle)
                                .multilineTextAlignment(.leading)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(menuTextColor)
                        }
                        .tint(menuTextColor)
                    }
                    
                    Spacer()
                }
            }
            .padding()
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
        } else {
            Text(post.title)
        }
    }
}

#Preview(body: {
    SwiftPresso.View.postListView(configuration: .init(host: "livsycode.com")) {
        SwiftPresso.View.shimmerPlaceholderView()
    }
})