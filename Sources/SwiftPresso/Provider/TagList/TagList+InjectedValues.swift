extension SwiftPressoInjectedValues {
    public var tagListProvider: any TagListProviderProtocol {
        get {
            Self[TagListProviderKey.self]
        }
        set {
            Self[TagListProviderKey.self] = newValue
        }
    }
}

private enum TagListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: any TagListProviderProtocol = SwiftPresso.Provider.tagListProvider()
}
