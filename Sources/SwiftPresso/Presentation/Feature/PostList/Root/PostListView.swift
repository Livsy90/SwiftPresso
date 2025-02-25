import SwiftUI
import ApricotNavigation

struct PostListView<Placeholder: View>: View {
    
    @Environment(Router.self) private var router
    @Environment(\.configuration) private var configuration: Preferences.Configuration
    
    @State private var size: CGSize = .zero
    @State private var viewModel: PostListViewModel
    @State private var searchText = ""
    @State private var urlToOpen: URL?
    
    @Binding private var externalTagName: String?
    @Binding private var externalCategoryName: String?
    
    @State private var isShowMenu = false
    
    @State private var isPageMenuExpanded: Bool = true
    @State private var isTagMenuExpanded: Bool = true
    @State private var isCategoryMenuExpanded: Bool = true
    @State private var chosenPage: PostModel?
    
    private let loadingPlaceholder: () -> Placeholder
    private var isTagViewDataLoading: Bool {
        viewModel.tagsToPresent.isEmpty
    }
    
    init(
        viewModel: PostListViewModel,
        externalTagName: Binding<String?>,
        externalCategoryName: Binding<String?>,
        loadingPlaceholder: @escaping () -> Placeholder
    ) {
        self.viewModel = viewModel
        _externalTagName = externalTagName
        _externalCategoryName = externalCategoryName
        
        self.loadingPlaceholder = loadingPlaceholder
    }
    
    var body: some View {
        List {
            tagView()
            
            listView()
            
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
        .scrollDismissesKeyboard(.interactively)
        .listStyle(.plain)
        .listRowSpacing(12)
        .scrollContentBackground(.hidden)
        .background {
            configuration.backgroundColor
                .edgesIgnoringSafeArea(.all)
        }
        .refreshable { [weak viewModel] in
            viewModel?.reload()
        }
        .navigationTitle(viewModel.mode.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(configuration.backgroundColor, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                navigationBarPrincipalItem()
                    .disabled(viewModel.isInitialLoading)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                navigationBarLeadingItem()
                    .disabled(viewModel.isInitialLoading)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem()
                    .disabled(viewModel.isInitialLoading)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            viewModel.search(searchText)
        }
        .onChange(of: searchText) { _, newValue in
            guard newValue.isEmpty else { return }
            DispatchQueue.main.async {
                self.viewModel.loadDefault()
            }
        }
        .onChange(of: externalTagName, { _, newValue in
            guard let newValue else { return }
            showPostListByTag(newValue)
        })
        .onChange(of: externalCategoryName, { _, newValue in
            guard let newValue else { return }
            showPostListByCategory(newValue)
        })
        .readSize($size)
        .webView(
            url: $urlToOpen,
            onTag: { tagName in
                showPostListByTag(tagName)
            },
            onCategory: { categoryName in
                showPostListByCategory(categoryName)
            },
            placeholder: {
                loadingPlaceholder()
                    .id(UUID())
            }
        )
        .sheet(isPresented: $isShowMenu, onDismiss: {
            openPageIfNeeded(chosenPage)
            chosenPage = nil
        }, content: {
            menu()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        })
        .task {
            isTagMenuExpanded = configuration.isMenuExpanded
            isPageMenuExpanded = configuration.isMenuExpanded
            isCategoryMenuExpanded = configuration.isMenuExpanded
        }
    }
    
}

// MARK: - Views

private extension PostListView {
    
    func menu() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if configuration.isShowPageMenu {
                    DisclosureGroup(
                        isExpanded: $isPageMenuExpanded,
                        content: {
                            ForEach(viewModel.pageList, id: \.self) { page in
                                Button {
                                    isShowMenu = false
                                    chosenPage = page
                                } label: {
                                    VStack {
                                        HStack {
                                            Text(page.title)
                                                .font(.callout)
                                                .multilineTextAlignment(.leading)
                                                .frame(alignment: .leading)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(configuration.menuTextColor)
                                            Spacer()
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                        },
                        label: {
                            Text(configuration.pageMenuTitle)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(configuration.menuTextColor)
                        }
                    )
                    .padding()
                    .tint(configuration.menuTextColor)
                }
                
                if configuration.isShowCategoryMenu {
                    DisclosureGroup(
                        isExpanded: $isCategoryMenuExpanded,
                        content: {
                            ForEach(viewModel.categories, id: \.self) { category in
                                Button {
                                    isShowMenu = false
                                    showPostListByCategory(category.name)
                                } label: {
                                    VStack {
                                        HStack {
                                            Text(category.name)
                                                .font(.callout)
                                                .multilineTextAlignment(.leading)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(configuration.menuTextColor)
                                            Spacer()
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                        },
                        label: {
                            Text(configuration.categoryMenuTitle)
                                .multilineTextAlignment(.leading)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(configuration.menuTextColor)
                        }
                    )
                    .padding()
                    .tint(configuration.menuTextColor)
                }
                
                if configuration.isShowTagMenu {
                    DisclosureGroup(
                        isExpanded: $isTagMenuExpanded,
                        content: {
                            ForEach(viewModel.tags, id: \.self) { tag in
                                Button {
                                    isShowMenu = false
                                    showPostListByTag(tag.name)
                                } label: {
                                    VStack {
                                        HStack {
                                            Text(tag.name)
                                                .font(.callout)
                                                .multilineTextAlignment(.leading)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(configuration.menuTextColor)
                                            Spacer()
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                        },
                        label: {
                            Text(configuration.tagMenuTitle)
                                .multilineTextAlignment(.leading)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(configuration.menuTextColor)
                        }
                    )
                    .padding()
                    .tint(configuration.menuTextColor)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(configuration.menuBackgroundColor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func tagRow(tag: CategoryModel) -> some View {
        Button {
            guard viewModel.chosenTag != tag else { return }
            viewModel.onTag(tag.name)
        } label: {
            Text(tag.name)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(configuration.accentColor.opacity(isTagChosen(tag) ? 0.5 : 0.15))
                }
        }
        .scalable()
    }
    
    func listView() -> some View {
        ForEach(viewModel.postList, id: \.self) { post in
            PostListRowView(
                post: post,
                onTag: { tagName in
                    showPostListByTag(tagName)
                },
                onCategory: { categoryName in
                    showPostListByCategory(categoryName)
                },
                placeholder: {
                    loadingPlaceholder()
                }
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .onAppear {
                viewModel.updateIfNeeded(id: post.id)
            }
        }
        .disabled(viewModel.isInitialLoading)
    }
    
    func tagPlaceholder() -> some View {
        tagRow(tag: .init(id: .zero, count: .zero, name: "Placeholder"))
            .opacity(0)
            .overlay {
                ShimmerView()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
    }
    
    @ViewBuilder
    func tagView() -> some View {
        ZStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0...100, id: \.self) { _ in
                        tagPlaceholder()
                    }
                }
            }
            .scrollDisabled(true)
            .opacity(isTagViewDataLoading ? 1 : 0)
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(viewModel.tagsToPresent, id: \.self) { tag in
                            tagRow(tag: tag)
                                .id(tag.id)
                        }
                    }
                }
                .onChange(of: viewModel.chosenTag ?? .init(id: 0, count: 0, name: "")) { _, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue.id)
                    }
                }
            }
            .opacity(isTagViewDataLoading ? 0 : 1)
        }
        .tagViewSettings()
        .background {
            configuration.backgroundColor
        }
    }
    
    func placeholder() -> some View {
        loadingPlaceholder()
            .id(UUID())
    }
    
    func navigationBarPrincipalItem() -> some View {
        HStack {
            Text(viewModel.mode.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .frame(width: size.width, alignment: .center)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func navigationBarTrailingItem() -> some View {
        if configuration.isShowTagMenu || configuration.isShowPageMenu || configuration.isShowCategoryMenu {
            Button {
                isShowMenu = true
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    func navigationBarLeadingItem() -> some View {
        HStack {
            Button {
                viewModel.loadDefault()
            } label: {
                configuration.homeIcon
            }
            .opacity(viewModel.isRefreshable ? 1 : 0)
            .symbolEffect(.bounce, value: viewModel.isRefreshable)
        }
    }
}

// MARK: - Helpers

private extension PostListView {
    
    func openPageIfNeeded(_ page: PostModel?) {
        guard let page else { return }
        
        if configuration.isShowContentInWebView {
            guard let url = page.link else { return }
            urlToOpen = url
        } else {
            router.navigate(to: Destination.postDetails(post: page))
        }
    }
    
    func showPostListByTag(_ tagName: String) {
        searchText.removeAll()
        viewModel.onTag(tagName)
    }
    
    func showPostListByCategory(_ categoryName: String) {
        searchText.removeAll()
        viewModel.onCategory(categoryName)
    }
    
    func isTagChosen(_ tag: CategoryModel) -> Bool {
        if let chosenTag = viewModel.chosenTag {
            chosenTag == tag
        } else if tag.id == .zero, viewModel.chosenTag == nil {
            true
        } else {
            false
        }
    }
    
}

private extension View {
    func tagViewSettings() -> some View {
        self
            .scrollIndicators(.hidden)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .frame(height: 80)
            .padding(.horizontal, 8)
    }
}

#Preview {
    SwiftPresso.View.default()
}
