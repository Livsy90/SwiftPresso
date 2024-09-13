extension SwiftPressoInjectedValues {
    public var postListProvider: any PostListProviderProtocol {
        get {
            Self[PostListProviderKey.self]
        }
        set {
            Self[PostListProviderKey.self] = newValue
        }
    }
}

private enum PostListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: any PostListProviderProtocol = SwiftPresso.Provider.postListProvider()
}
