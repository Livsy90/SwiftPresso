import SwiftUI
import ApricotNavigation

struct PostListView: View {
    
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
    
    private var isTagViewDataLoading: Bool {
        viewModel.tagsToPresent.isEmpty
    }
    
    private var gradientColors: [Color] {
        [
            configuration.backgroundColor.opacity(0),
            configuration.backgroundColor.opacity(0.4),
            configuration.backgroundColor.opacity(0.8),
            configuration.backgroundColor.opacity(0.96),
            configuration.backgroundColor
        ]
    }
    
    init(
        viewModel: PostListViewModel,
        externalTagName: Binding<String?>,
        externalCategoryName: Binding<String?>
    ) {
        self.viewModel = viewModel
        _externalTagName = externalTagName
        _externalCategoryName = externalCategoryName
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            list()
            ProgressIndicator(.large)
                .opacity(viewModel.isInitialLoading ? 1 : 0)
        }
    }
    
}

// MARK: - Views

private extension PostListView {
    
    func list() -> some View {
        List {
            tagView()
            title()
            descriptionView(viewModel.chosenTag)
            listView()
            loadMoreIndicator()
        }
        .scrollDisabled(viewModel.isInitialLoading)
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
        .navigationTitle(configuration.homeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(configuration.backgroundColor, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                navigationBarPrincipalItem()
            }
            
            ToolbarItem(placement: .topBarLeading) {
                navigationBarLeadingItem()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem()
                    .disabled(viewModel.isTaxonomiesLoading)
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
                ProgressIndicator(.large)
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
                .presentationBackground(.ultraThinMaterial)
        })
        .task {
            isTagMenuExpanded = configuration.isMenuExpanded
            isPageMenuExpanded = configuration.isMenuExpanded
            isCategoryMenuExpanded = configuration.isMenuExpanded
        }
    }
    
    @ViewBuilder
    func title() -> some View {
        if let title = viewModel.mode.title {
            Text(title)
                .foregroundStyle(configuration.textColor)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 8)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
    }
    
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
                                                .foregroundStyle(configuration.textColor)
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
                                .foregroundStyle(configuration.textColor)
                        }
                    )
                    .padding()
                    .tint(configuration.textColor)
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
                                                .foregroundStyle(configuration.textColor)
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
                                .foregroundStyle(configuration.textColor)
                        }
                    )
                    .padding()
                    .tint(configuration.textColor)
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
                                                .foregroundStyle(configuration.textColor)
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
                                .foregroundStyle(configuration.textColor)
                        }
                    )
                    .padding()
                    .tint(configuration.textColor)
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func tagItem(tag: CategoryModel) -> some View {
        Button {
            guard viewModel.chosenTag != tag else { return }
            viewModel.onTag(tag.name)
        } label: {
            Text(tag.name)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(isTagChosen(tag) ? configuration.menuTextColor : configuration.textColor)
                .padding()
                .background {
                    filledRectangle(isTagChosen(tag))
                }
        }
        .scalable()
    }
    
    @ViewBuilder
    func filledRectangle(_ isChosen: Bool) -> some View {
        if isChosen {
            RoundedRectangle(cornerRadius: 12)
                .fill(configuration.accentColor)
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        }
    }
    
    @ViewBuilder
    func descriptionView(_ model: CategoryModel?) -> some View {
        if let model {
            Text(model.description)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .foregroundStyle(configuration.textColor)
                .padding(.horizontal, 8)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
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
                    ProgressIndicator(.large)
                }
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .onAppear {
                viewModel.updateIfNeeded(id: post.id)
            }
        }
    }
    
    func tagPlaceholder() -> some View {
        tagItem(tag: .placeholder)
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
                            tagItem(tag: tag)
                                .id(tag.id)
                                .visualEffect { content, proxy in
                                    let frame = proxy.frame(in: .scrollView(axis: .horizontal))
                                    let distance = min(0, frame.minX)
                                    
                                    return content
                                        .hueRotation(.degrees(frame.origin.x / 10)) // Changed y to x
                                        .scaleEffect(1 + distance / 700)
                                        .offset(x: -distance / 1.25) // Changed y offset to x offset
                                        .brightness(-distance / 400)
                                        .blur(radius: -distance / 50)
                                }
                        }
                    }
                }
                .onChange(of: viewModel.chosenTag ?? .empty) { _, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue.id, anchor: .center)
                    }
                }
            }
            .opacity(isTagViewDataLoading ? 0 : 1)
        }
        .tagViewSettings()
        .background {
            configuration.backgroundColor
        }
        .overlay {
            HStack(spacing: 0) {
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .trailing,
                    endPoint: .leading
                )
                .frame(width: 18)
                Rectangle()
                    .opacity(0)
            }
        }
        .overlay {
            HStack(spacing: 0) {
                Rectangle()
                    .opacity(0)
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 18)
            }
        }
    }
    
    func navigationBarPrincipalItem() -> some View {
        HStack {
            Text(configuration.homeTitle)
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
    
    func loadMoreIndicator() -> some View {
        ProgressIndicator(.small)
            .opacity(viewModel.isLoadMore ? 1 : 0)
            .frame(maxWidth: .infinity, alignment: .center)
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
            .contentMargins(.horizontal, 8, for: .scrollContent)
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
