extension SwiftPressoInjectedValues {
    public var page: PageProviderProtocol {
        get {
            Self[PageProviderKey.self]
        }
        set {
            Self[PageProviderKey.self] = newValue
        }
    }
}

private enum PageProviderKey: SwiftPressoInjectionKey {
    static var currentValue: PageProviderProtocol = SwiftPresso.Provider.pageProvider()
}
