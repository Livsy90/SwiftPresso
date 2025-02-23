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
                .stroked()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .onAppear {
                    viewModel.updateIfNeeded(id: post.id)
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
        .scrollDismissesKeyboard(.interactively)
        .listStyle(.plain)
        .listRowSpacing(14)
        .scrollContentBackground(.hidden)
        .background {
            Rectangle()
                .fill(configuration.backgroundColor)
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
            }
            
            ToolbarItem(placement: .topBarLeading) {
                navigationBarLeadingItem()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarTrailingItem()
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
        .onGeometryChange(for: CGSize.self) { geometry in
            return geometry.size
        } action: { newValue in
            size = newValue
        }
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
        .disabled(viewModel.isInitialLoading)
        .task {
            isTagMenuExpanded = configuration.isMenuExpanded
            isPageMenuExpanded = configuration.isMenuExpanded
            isCategoryMenuExpanded = configuration.isMenuExpanded
        }
    }
    
    private func placeholder() -> some View {
        loadingPlaceholder()
            .id(UUID())
    }
    
    private func navigationBarPrincipalItem() -> some View {
        HStack {
            Text(viewModel.mode.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .frame(width: size.width, alignment: .center)
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func navigationBarTrailingItem() -> some View {
        if configuration.isShowTagMenu || configuration.isShowPageMenu || configuration.isShowCategoryMenu {
            Button {
                isShowMenu = true
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
    
    private func navigationBarLeadingItem() -> some View {
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
    
    private func menu() -> some View {
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
    
    private func openPageIfNeeded(_ page: PostModel?) {
        guard let page else { return }
        
        if configuration.isShowContentInWebView {
            guard let url = page.link else { return }
            urlToOpen = url
        } else {
            router.navigate(to: Destination.postDetails(post: page))
        }
    }
    
    private func showPostListByTag(_ tagName: String) {
        searchText.removeAll()
        viewModel.onTag(tagName)
    }
    
    private func showPostListByCategory(_ categoryName: String) {
        searchText.removeAll()
        viewModel.onCategory(categoryName)
    }
    
}

#Preview {
    SwiftPresso.configure(
        host: "livsycode.com",
        isShowContentInWebView: false
    )
    return SwiftPresso.View.postList()
}
