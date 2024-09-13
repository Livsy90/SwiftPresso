extension SwiftPressoInjectedValues {
    public var postProvider: any PostProviderProtocol {
        get {
            Self[PostProviderKey.self]
        }
        set {
            Self[PostProviderKey.self] = newValue
        }
    }
}

private enum PostProviderKey: SwiftPressoInjectionKey {
    static var currentValue: any PostProviderProtocol = SwiftPresso.Provider.postProvider()
}
