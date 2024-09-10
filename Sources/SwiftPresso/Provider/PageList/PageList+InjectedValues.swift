extension SwiftPressoInjectedValues {
    public var pageList: PageListProviderProtocol {
        get {
            Self[PageListProviderKey.self]
        }
        set {
            Self[PageListProviderKey.self] = newValue
        }
    }
}

private enum PageListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: PageListProviderProtocol = SwiftPresso.Provider.pageListProvider()
}
