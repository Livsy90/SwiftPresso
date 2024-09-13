extension SwiftPressoInjectedValues {
    public var pageListProvider: any PageListProviderProtocol {
        get {
            Self[PageListProviderKey.self]
        }
        set {
            Self[PageListProviderKey.self] = newValue
        }
    }
}

private enum PageListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: any PageListProviderProtocol = SwiftPresso.Provider.pageListProvider()
}
