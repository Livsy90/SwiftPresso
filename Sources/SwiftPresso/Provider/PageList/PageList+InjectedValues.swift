extension InjectedValues {
    public var pageList: PageListProviderProtocol {
        get {
            Self[PageListProviderKey.self]
        }
        set {
            Self[PageListProviderKey.self] = newValue
        }
    }
}

private enum PageListProviderKey: InjectionKey {
    static var currentValue: PageListProviderProtocol = SwiftPresso.Provider.pageListProvider()
}
