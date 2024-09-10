extension SwiftPressoInjectedValues {
    public var postList: PostListProviderProtocol {
        get {
            Self[PostListProviderKey.self]
        }
        set {
            Self[PostListProviderKey.self] = newValue
        }
    }
}

private enum PostListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: PostListProviderProtocol = SwiftPresso.Provider.postListProvider()
}
