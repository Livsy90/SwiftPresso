extension SwiftPressoInjectedValues {
    public var categoryListProvider: any CategoryListProviderProtocol {
        get {
            Self[CategoryListProviderKey.self]
        }
        set {
            Self[CategoryListProviderKey.self] = newValue
        }
    }
}

private enum CategoryListProviderKey: SwiftPressoInjectionKey {
    static var currentValue: any CategoryListProviderProtocol = SwiftPresso.Provider.categoryListProvider()
}
