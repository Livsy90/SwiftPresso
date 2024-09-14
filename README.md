# SwiftPresso

SwiftPresso connects your Wordpress website and your Swift app.

With just one line of code, you can convert your WordPress website to an iOS app. SwiftPresso provides customizable SwiftUI Views to display your website content.

If you prefer full control, you can create your own entities and use SwiftPresso only to manage networking and domain models.

You can also use SwiftPresso HTML mapper to transform HTML text into `NSAttributedString`.

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
            SwiftPresso.View.postList("livsycode.com")
        }
    }
}
```

With this configuration, you can determine the API host value, the HTTP method, and various UI parameters.

```swift
@main
struct DemoApp: App {
        
    var body: some Scene {
        WindowGroup {
            SwiftPresso.View.postList(
                .init(
                    host: "livsycode.com",
                    backgroundColor: .black,
                    tagMenuTitle: "Series"
                )
            )
        }
    }
}
```

There are two ways to display post content:
* Using HTML content mapped to an `NSAttributedString`.
* Using WebView.

To choose between these options, you can set the configuration value. 

```swift
SwiftPresso.View.postList(.init(host: "livsycode.com", isShowContentInWebView: true))
```

### Important: 
If you prefer the first option, remember to edit your Info.plist file to add a permission string about photo library usage since SwiftPresso allows users to save images to a camera roll. Select "Privacy - Photo Library Additions Usage Description" to add this string.

# Permalinks

If there are links to other posts within your posts, you can open them without leaving the app. You can enable this feature by changing the permalink structure in the WordPress admin settings. To do this, go to the WordPress admin panel and open Settings -> Permalinks. The application needs information about the post ID at the end of the URL to know which post a link is leading to. Thus, you can prescribe, for example, such a scheme:

```
/%category%/%postname%/%post_id%/
```

Using WebView gives this option by default. However, for a tap on a link leading to a tag or category to return you to a list of posts already filtered by this tag or category, you need to change the permalinks so they contain a `tag` or `category` path component. Like this, for example:

```
/%category%/%postname%/
```

Or like in the example above:

```
/%category%/%postname%/%post_id%/
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

If you use SwiftPresso built-in views, there is no need to worry about the configuration method calling. However, using SwiftPresso entities separately must be preceded by manually configuring the data. To do this, you can use the SwiftPresso configure method.

```swift
SwiftPresso.Configuration.configure(with: .init(host: "livsycode.com", httpScheme: .https))
```

The SwiftPresso Configuration stores values to manage API requests and handle UI appearance.

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

To use property wrappers inside an Observable class scope, you can mark properties with the @ObservationIgnored Macro.

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
            tags: [1,2,3]
        )
        
        let rawData = try? await postListProvider.getRawPosts(
            pageNumber: 1,
            perPage: 20,
            searchTerms: "some text...",
            categories: [1,2,3],
            tags: [1,2,3]
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
        fontStyle: .callout,
        width: 375,
        isHandleYouTubeVideos: true
    )
}
```

```swift
@ObservationIgnored
@SwiftPressoInjected(\.htmlMapper)
var mapper: HTMLMapperProtocol

func map(post: PostModel) -> NSAttributedString {
    mapper.attributedStringFrom(
        htmlText: post.content,
        color: .black,
        fontStyle: .callout,
        width: 375,
        isHandleYouTubeVideos: true
    )
}
```

# Screenshots

### Post list
<img src="https://github.com/Livsy90/SwiftPresso/blob/main/demo2.png" width ="300">

## Post

<img src="https://github.com/Livsy90/SwiftPresso/blob/main/demo1.png" width ="300">

## Menu

<img src="https://github.com/Livsy90/SwiftPresso/blob/main/demo3.png" width ="300">
