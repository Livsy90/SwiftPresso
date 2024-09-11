extension SwiftPressoInjectedValues {
    public var post: PostProviderProtocol {
        get {
            Self[PostProviderKey.self]
        }
        set {
            Self[PostProviderKey.self] = newValue
        }
    }
}

private enum PostProviderKey: SwiftPressoInjectionKey {
    static var currentValue: PostProviderProtocol = SwiftPresso.Provider.postProvider()
}
