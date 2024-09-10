extension SwiftPressoInjectedValues {
    public var tagList: TagListProviderProtocol {
        get {
            Self[TagListProviderKey.self]
        }
        set {
            Self[TagListProviderKey.self] = newValue
        }
    }
}

private enum TagListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: TagListProviderProtocol = SwiftPresso.Provider.tagListProvider()
}
