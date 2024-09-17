# SwiftPresso

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FLivsy90%2FSwiftPresso%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Livsy90/SwiftPresso)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FLivsy90%2FSwiftPresso%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Livsy90/SwiftPresso)

SwiftPresso connects your Wordpress website and your Swift app.

With just one line of code, you can convert your WordPress website to an iOS app. SwiftPresso provides customizable SwiftUI Views to display your website content.

If you prefer full control, you can create your own entities and use SwiftPresso only to manage networking and domain models.

You can also use SwiftPresso HTML mapper to transform HTML text into `NSAttributedString`.

The article about SwiftPresso: https://livsycode.com/swift/connect-your-ios-app-to-wordpress-wit-swiftpresso/

## Installation

### SPM:
.package(url: "https://github.com/Livsy90/SwiftPresso.git", from: "2.0.0")

## Built-in View

You can call the SwiftPresso factory method to use the built-in post-list view and inject the desired configuration. 

```swift
@main
struct DemoApp: App {
        
    var body: some Scene {
        WindowGroup {
            SwiftPresso.View.postList(host: "livsycode.com")
        }
    }
}
```

With this configuration, you can determine the API host value, the HTTP method, and various UI parameters.

```swift
    SwiftPresso.View.postList(
    host: "livsycode.com",
    backgroundColor: .blue,
    interfaceColor: .white,
    textColor: .white
)
```

There are two ways to display post content:
* Using HTML content mapped to an `NSAttributedString`.
* Using WebView.

To choose between these options, you can set the configuration value. 

```swift
SwiftPresso.View.postList(host: "livsycode.com", isShowContentInWebView: true)
```

### Important: 
If you prefer the first option, remember to edit your Info.plist file to add a permission string about photo library usage since SwiftPresso allows users to save images to a camera roll. Select "Privacy - Photo Library Additions Usage Description" to add this string.

# Permalinks

If there are links to other posts within your posts, you can open them without leaving the app. You can enable this feature by changing the permalink structure in the WordPress admin settings. To do this, go to the WordPress admin panel and open Settings -> Permalinks. The application needs information about the post ID at the end of the URL to know which post a link is leading to. Thus, you can prescribe, for example, such a scheme:

```
/%category%/%postname%/%post_id%/
```

Using WebView gives this option by default. However, for a tap on a link leading to a tag or category to return you to a list of posts already filtered by this tag or category, you need to change the permalinks to contain a tag and a category path component. Like this, for example.

```
/%category%/%postname%/
```

Or like in the example above:

```
/%category%/%postname%/%post_id%/
```

You can customize tag and category components as well.

```swift
    SwiftPresso.View.postList(
        host: "livsycode.com",
        tagPathComponent: "series",
        categoryPathComponent: "topics"
    )
```

### Important:
Changing permalinks will affect your SEO settings, so do this cautiously.

## Loading indicator

While the default implementation contains the shimmer loading indicator, which will be used while loading data for the post list and a single post, you can also use the second method to provide a custom one.

```swift
@main
struct DemoApp: App {
        
    var body: some Scene {
        WindowGroup {
            SwiftPresso.View.postList("livsycode.com") {
                ProgressView()
            }
        }
    }
}
```

## Configuration

If you use SwiftPresso built-in views, you don't need to worry about the configuration method calling. However, when utilizing SwiftPresso entities individually, you must manually configure the data. To do this, you can use the configure method.

```swift
    /// - Parameters:
    ///   - host: API host.
    ///   - httpScheme: API HTTP scheme.
    ///   - postsPerPage: Posts per page in the post list request.
    ///   - tagPathComponent: API Tag path component.
    ///   - categoryPathComponent: API Category path component.
    ///   - isShowContentInWebView: Using WKWebView as post view.
    ///   - isShowFeaturedImage: Post featured image visibility.
    ///   - backgroundColor: Post list and post view background color.
    ///   - interfaceColor: Post list and post view interface color.
    ///   - textColor: Post list and post view text color.
    ///   - postListFont: Post list font.
    ///   - postBodyFont: Post body font.
    ///   - postTitleFont: Post title font.
    ///   - menuBackgroundColor: Menu background color.
    ///   - menuTextColor: Menu text color.
    ///   - homeIcon: The icon for the navigation bar button that restores the interface to its default state.
    ///   - homeTitle: Navigation title for default state.
    ///   - searchTitle: Navigation title for search state.
    ///   - isShowPageMenu: Determines the visibility of the page menu.
    ///   - isShowTagMenu: Determines the visibility of the tag menu.
    ///   - isShowCategoryMenu: Determines the visibility of the category menu.
    ///   - pageMenuTitle: Determines the title of the page menu.
    ///   - tagMenuTitle: Determines the title of the tag menu.
    ///   - categoryMenuTitle: Determines the title of the category menu.
    ///   - isParseHTMLWithYouTubePreviews: If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with an active link.
    ///   - isExcludeWebHeaderAndFooter: Remove web page's header and footer.
    ///   - isMenuExpanded: To expand menu items by default.
    static func configure(
        host: String,
        httpScheme: HTTPScheme = .https,
        postsPerPage: Int = 50,
        tagPathComponent: String = "tag",
        categoryPathComponent: String = "category",
        isShowContentInWebView: Bool = false,
        isShowFeaturedImage: Bool = true,
        postListFont: Font = .title2,
        postBodyFont: UIFont = .systemFont(ofSize: 17),
        postTitleFont: Font = .largeTitle,
        backgroundColor: Color = Color(uiColor: .systemBackground),
        interfaceColor: Color = .primary,
        textColor: Color = .primary,
        menuBackgroundColor: Color = .primary,
        menuTextColor: Color = Color(uiColor: .systemBackground),
        homeIcon: Image = Image(systemName: "house"),
        homeTitle: String = "Home",
        searchTitle: String = "Search",
        isShowPageMenu: Bool = true,
        isShowTagMenu: Bool = true,
        isShowCategoryMenu: Bool = true,
        pageMenuTitle: String = "Pages",
        tagMenuTitle: String = "Tags",
        categoryMenuTitle: String = "Category",
        isParseHTMLWithYouTubePreviews: Bool = true,
        isExcludeWebHeaderAndFooter: Bool = true,
        isMenuExpanded: Bool = true
    ) { ... }
```

```swift
SwiftPresso.configure(host: "livsycode.com", httpScheme: .https)
```

The `SwiftPresso.Configuration` stores values to manage API requests and handle UI appearance.

```swift
 extension SwiftPresso {
    
    enum Configuration {
        
         enum API {
            
            /// API host.
             static var host: String { get }
            
            /// Posts per page in the post list request.
             static var postsPerPage: Int { get }
            
            /// API HTTP scheme.
             static var httpScheme: HTTPScheme { get }
            
            /// API Tag path component.
             static var tagPathComponent: String { get }
            
            /// API Category path component.
             static var categoryPathComponent: String { get }
            
        }
        
         enum UI {
            
            /// Remove web page's header and footer.
             static var isExcludeWebHeaderAndFooter: Bool { get }
            
            /// Post list and post view background color.
             static var backgroundColor: Color { get }
            
            /// Post list and post view interface color.
             static var interfaceColor: Color { get }
            
            /// Post list and post view text color.
             static var textColor: Color { get }
             
            /// Post list font.
            static var postListFont: Font { get }
            
            /// Post body font.
            static var postBodyFont: UIFont.TextStyle { get }
            
            /// Post title font.
            static var postTitleFont: Font { get }
            
             /// Post featured image visibility.
            static var isShowFeaturedImage: Bool { get }
            
            /// Determines the visibility of the page menu.
             static var isShowPageMenu: Bool { get }
            
            /// Determines the visibility of the tag menu.
             static var isShowTagMenu: Bool { get }
            
            /// Determines the visibility of the category menu.
             static var isShowCategoryMenu: Bool { get }
            
            /// The icon for the navigation bar button that restores the interface to its default state.
             static var homeIcon: Image { get }
            
            /// Determines the title of the page menu.
             static var pageMenuTitle: String { get }
            
            /// Determines the title of the tag menu.
             static var tagMenuTitle: String { get }
            
            /// Determines the title of the category menu.
             static var categoryMenuTitle: String { get }
            
            /// Navigation title for default state.
             static var homeTitle: String { get }
            
            /// Navigation title for search state.
             static var searchTitle: String { get }
            
            /// Menu background color.
             static var menuBackgroundColor: Color { get }
            
            /// Menu text color.
             static var menuTextColor: Color { get }
            
            /// To expand menu items by default.
             static var isMenuExpanded: Bool { get }
            
            /// Using WKWebView as post view.
             static var isShowContentInWebView: Bool { get }
            
            /// If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with an active link.
             static var isParseHTMLWithYouTubePreviews: Bool { get }
            
        }
        
    }
    
}

```

```swift
let host = SwiftPresso.Configuration.API.host
let color = SwiftPresso.Configuration.UI.backgroundColor
```

## Data Providers

To use SwiftPresso providers, you can inject them via SwiftPresso property wrappers. 

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.categoryListProvider)
    var categoryListProvider: CategoryListProviderProtocol
    
}
```

Alternatively, you can use the SwiftPresso factory methods. 

```swift
let postListProvider = SwiftPresso.Provider.postListProvider()
```

To use property wrappers inside an `Observable` class, you can mark properties with the `@ObservationIgnored` Macro.

```swift
@Observable
class ViewModel {
    
    @ObservationIgnored
    @SwiftPressoInjected(\.categoryListProvider)
    var categoryListProvider: CategoryListProviderProtocol
    
}
```

There are six providers in SwiftPresso:
* Post list provider.
* Single post provider.
* Page list provider.
* Single page provider.
* Category list provider.
* Tag list provider.

### Post List Provider

The post list provider has two methods for retrieving an array of post models, which return two different types of post models in SwiftPresso.
* The first one provides a lightweight model, which includes only crucial data. 
* The second provider returns an array of raw data models.

You can configure several parameters to perform the request:
* Page number.
* Posts per page.
* Search terms.
* Categories
* Tags.
* Post IDs.

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.postListProvider)
    var postListProvider: PostListProviderProtocol
    
    func getData() async {
        let data = try? await postListProvider.getPosts(
            pageNumber: 1,
            perPage: 20,
            searchTerms: "some text...",
            categories: [1,2,3],
            tags: [1,2,3],
            includeIDs: [1,22]
        )
        
        let rawData = try? await postListProvider.getRawPosts(
            pageNumber: 1,
            perPage: 20,
            searchTerms: "some text...",
            categories: [1,2,3],
            tags: [1,2,3],
            includeIDs: [1,22]
        )
    }
    
}
```

### Single post Provider

The single post provider has two methods for retrieving a specific post model.
* The first one provides a lightweight model, which includes only crucial data. 
* The second provider returns the raw data model.

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.postProvider)
    var postProvider: PostProviderProtocol
        
    func getData() async {
        let data = try? await postProvider.getPost(id: 55)
        let rawData = try? await postProvider.getRawPost(id: 55)
    }
    
}
```

### Page List Provider

As the post list provider, the page list provider also has two methods for retrieving an array of page models, which return two types of page models in SwiftPresso.
* The first one provides a lightweight model, which includes only crucial data. 
* The second provider returns an array of raw data models.

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.pageListProvider)
    var pageListProvider: PageListProviderProtocol
        
    func getData() async {
        let data = try? await pageListProvider.getPages()
        let rawData = try? await pageListProvider.getRawPages()
    }
    
}
```

### Single Page Provider

The page provider also has two methods for retrieving a page model.
* The first one provides a lightweight model, which includes only crucial data. 
* The second provider returns the raw data model.

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.pageProvider)
    var pageProvider: PageProviderProtocol
        
    func getData() async {
        let data = try? await pageProvider.getPage(id: 22)
        let rawData = try? await pageProvider.getRawPage(id: 22)
    }
    
}
```

### Category / Tag List Provider

The category and the tag list providers provide an array of models, which is a Category type.

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.categoryListProvider)
    var categoryListProvider: CategoryListProviderProtocol
    
    func getData() async {
        let data = try? await categoryListProvider.getCategories()
    }
    
}
```

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.tagListProvider)
    var tagListProvider: TagListProviderProtocol
        
    func getData() async {
        let data = try? await tagListProvider.getTags()
    }
    
}
```

## HTML Mapper

The HTML mapper can transform an HTML text into an `NSAttributedString`. If an HTML text contains a link to a YouTube video, it will be displayed as a preview of that video with a clickable link.

```swift
let mapper = SwiftPresso.Mapper.htmlMapper()

func map(post: PostModel) -> NSAttributedString {
    mapper.attributedStringFrom(
        htmlText: post.content,
        color: .black,
        font: .systemFont(ofSize: 17),
        width: 375,
        isHandleYouTubeVideos: true
    )
}
```

```swift
@SwiftPressoInjected(\.htmlMapper)
var mapper: HTMLMapperProtocol

func map(post: PostModel) -> NSAttributedString {
    mapper.attributedStringFrom(
        htmlText: post.content,
        color: .black,
        font: .systemFont(ofSize: 17),
        width: 375,
        isHandleYouTubeVideos: true
    )
}
```

# Screenshots

## Post list

<img src="https://github.com/Livsy90/SwiftPresso/blob/main/demo2.png" width ="300">

## Post

<img src="https://github.com/Livsy90/SwiftPresso/blob/main/demo1.png" width ="300">

## Menu

<img src="https://github.com/Livsy90/SwiftPresso/blob/main/demo3.png" width ="300">

# Requirements

* iOS 17+
* Xcode 15+
