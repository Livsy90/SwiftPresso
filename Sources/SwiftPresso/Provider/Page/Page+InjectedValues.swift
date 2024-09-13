extension SwiftPressoInjectedValues {
    public var page: any PageProviderProtocol {
        get {
            Self[PageProviderKey.self]
        }
        set {
            Self[PageProviderKey.self] = newValue
        }
    }
}

private enum PageProviderKey: SwiftPressoInjectionKey {
    static var currentValue: any PageProviderProtocol = SwiftPresso.Provider.pageProvider()
}
