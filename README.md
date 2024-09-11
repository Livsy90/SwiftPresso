# SwiftPresso

SwiftPresso connects your Wordpress website and your Swift app.

With just one line of code, you can convert your WordPress website to an iOS app. SwiftPresso provides a customizable SwiftUI View to display your website posts.

If you prefer full control, you can create your own entities and use SwiftPresso only to manage networking and domain models.

You can also use SwiftPresso HTML mapper to transform HTML text into NSAttributedString.

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
    
    private let backgroundColor = Color(.black)
    
    var body: some Scene {
        WindowGroup {
            SwiftPresso.View.postList(
                .init(
                    host: "livsycode.com",
                    backgroundColor: backgroundColor,
                    tagMenuTitle: "Series"
                )
            )
        }
    }
}
```

While the default implementation contains the shimmer placeholder, which will be used while loading data from the post list and a single post, you can also use the second method to provide a custom one.

```swift
@main
struct DemoApp: App {
        
    var body: some Scene {
        WindowGroup {
            SwiftPresso.View.postListWithCustomPlaceholder("livsycode.com") {
                ProgressView()
            }
        }
    }
}
```

## Configuration

While using the built-in post list view has its own configuration under the cut, using SwiftPresso entities separately must be preceded by manually configuring the data. To do this, you can use the SwiftPresso configure method.

```swift
SwiftPresso.Configuration.configure(with: .init(host: "livsycode.com", httpScheme: .https))
```

The SwiftPresso Configuration stores values to manage API requests and handle UI appearance.

## Data Providers

To use SwiftPresso providers, you can inject them via SwiftPresso property wrappers. 

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.categoryList)
    var categoryListProvider: CategoryListProviderProtocol
    
}
```

Alternatively, you can use the SwiftPresso factory methods. 

```swift
class ViewModel {
    
    var postListProvider = SwiftPresso.Provider.postListProvider()
    
}
```

To use property wrappers inside an Observable class scope, you can mark properties with the @ObservationIgnored Macro.

```swift
@Observable
class ViewModel {
    
    @ObservationIgnored
    @SwiftPressoInjected(\.categoryList)
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
    
    @SwiftPressoInjected(\.postList)
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
    
    @SwiftPressoInjected(\.post)
    var postProvider: PostProviderProtocol
        
    func getData() async {
        let data = try? await postProvider.getPost(id: 55)
    }
    
}
```

### Page List Provider

As the post list provider, the page list provider also has two methods for retrieving an array of page models, which return two types of page models in SwiftPresso.
* The first one provides a lightweight model, which includes only crucial data. 
* The second provider returns an array of raw data models.

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.pageList)
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
    
    @SwiftPressoInjected(\.page)
    var pageProvider: PageProviderProtocol
        
    func getData() async {
        let data = try? await pageProvider.getPage(id: 22)
    }
    
}
```

### Category / Tag List Provider

The category and the tag list providers provide an array of models, which is a Category type.

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.categoryList)
    var categoryListProvider: CategoryListProviderProtocol
    
    func getData() async {
        let data = try? await categoryListProvider.getCategories()
    }
    
}
```

```swift
class ViewModel {
    
    @SwiftPressoInjected(\.tagList)
    var tagListProvider: TagListProviderProtocol
        
    func getData() async {
        let data = try? await tagListProvider.getTags()
    }
    
}
```

## HTML Mapper

The HTML mapper can trasform a HTML text into the NSAtributted String.  If the HTML text contains a link to a YouTube video, it will display as a preview of that video with a clickable link.

```swift
let mapper = SwiftPresso.Mapper.htmlMapper()

func map(post: PostModel) -> NSAttributedString {
    mapper.attributedStringFrom(htmlText: post.content, width: 375)
}
```
